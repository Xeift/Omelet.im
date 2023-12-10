// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class SafeOpkStore implements PreKeyStore {
  final storage = const FlutterSecureStorage();

  static const String fssKey = 'opk';

  @override
  Future<PreKeyRecord> loadPreKey(int preKeyId) async {
    final opks = jsonDecode((await storage.read(key: fssKey)).toString());
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
    Map<String, dynamic> preKeys =
        jsonDecode((await storage.read(key: fssKey)).toString()) ?? {};

    preKeys[preKeyId.toString()] = jsonEncode(record.serialize());

    await storage.write(key: fssKey, value: jsonEncode(preKeys));
  }

  @override
  Future<bool> containsPreKey(int preKeyId) async {
    final preKeys = jsonDecode((await storage.read(key: fssKey)).toString());
    if (preKeys == null) {
      throw InvalidKeyIdException('no prekey found');
    }

    final singlePreKey = preKeys[preKeyId.toString()];

    return singlePreKey != null;
  }

  @override
  Future<void> removePreKey(int preKeyId) async {
    var preKeys = jsonDecode((await storage.read(key: fssKey)).toString());
    if (preKeys == null) {
      throw InvalidKeyIdException('no prekey found');
    }

    preKeys.remove(preKeyId.toString());

    await storage.write(key: fssKey, value: jsonEncode(preKeys));
  }
}
