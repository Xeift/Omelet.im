import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:omelet/storage/safe_account_store.dart';

class SafeOpkStore implements PreKeyStore {
  final storage = const FlutterSecureStorage();

  @override
  Future<PreKeyRecord> loadPreKey(int preKeyId) async {
    final ourCurrentUid = await loadCurrentActiveAccount();

    final opks = jsonDecode(
        (await storage.read(key: '${ourCurrentUid}_selfOpk')).toString());
    if (opks == null) {
      throw InvalidKeyIdException('no prekey found');
    }

    final singleOPK = opks[preKeyId.toString()];
    if (singleOPK == null) {
      throw InvalidKeyIdException('No such prekey record: $preKeyId');
    }

    return PreKeyRecord.fromBuffer(
        Uint8List.fromList(jsonDecode(singleOPK).cast<int>().toList()));
  }

  @override
  Future<void> storePreKey(int preKeyId, PreKeyRecord record) async {
    final ourCurrentUid = await loadCurrentActiveAccount();
    Map<String, dynamic> preKeys = jsonDecode(
            (await storage.read(key: '${ourCurrentUid}_selfOpk')).toString()) ??
        {};

    preKeys[preKeyId.toString()] = jsonEncode(record.serialize());
    final ourUid = await loadCurrentActiveAccount();

    await storage.write(key: '${ourUid}_selfOpk', value: jsonEncode(preKeys));
  }

  @override
  Future<bool> containsPreKey(int preKeyId) async {
    final ourCurrentUid = await loadCurrentActiveAccount();
    final preKeys = jsonDecode(
        (await storage.read(key: '${ourCurrentUid}_selfOpk')).toString());
    if (preKeys == null) {
      throw InvalidKeyIdException('no prekey found');
    }

    final singlePreKey = preKeys[preKeyId.toString()];

    return singlePreKey != null;
  }

  @override
  Future<void> removePreKey(int preKeyId) async {
    final ourCurrentUid = await loadCurrentActiveAccount();
    var preKeys = jsonDecode(
        (await storage.read(key: '${ourCurrentUid}_selfOpk')).toString());
    if (preKeys == null) {
      throw InvalidKeyIdException('no prekey found');
    }

    preKeys.remove(preKeyId.toString());
    final ourUid = await loadCurrentActiveAccount();
    await storage.write(key: '${ourUid}_selfOpk', value: jsonEncode(preKeys));
  }
}
