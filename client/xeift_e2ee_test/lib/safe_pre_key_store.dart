// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class SafePreKeyStore implements PreKeyStore {
  final FlutterSecureStorage storage;

  SafePreKeyStore(this.storage);

  static const String preKey = 'preKey';

  @override
  Future<bool> containsPreKey(int preKeyId) async {
    final preKeys = jsonDecode((await storage.read(key: preKey)).toString());
    if (preKeys == null) {
      throw InvalidKeyIdException('no prekey found');
    }

    final singlePreKey = preKeys[preKeyId.toString()];

    return singlePreKey != null;
  }

  @override
  Future<PreKeyRecord> loadPreKey(int preKeyId) async {
    final preKeys = jsonDecode((await storage.read(key: preKey)).toString());
    if (preKeys == null) {
      throw InvalidKeyIdException('no prekey found');
    }

    final singlePreKey = preKeys[preKeyId.toString()];
    if (singlePreKey == null) {
      throw InvalidKeyIdException('No such prekey record: $preKeyId');
    }

    return PreKeyRecord.fromBuffer(Uint8List.fromList( jsonDecode(singlePreKey).cast<int>().toList() ));
  }

  @override
  Future<void> removePreKey(int preKeyId) async {
    var preKeys = jsonDecode((await storage.read(key: preKey)).toString());
    if (preKeys == null) {
      throw InvalidKeyIdException('no prekey found');
    }

    preKeys.remove(preKeyId.toString());

    await storage.write(
      key: preKey,
      value: jsonEncode(preKeys)
    );
  }

  @override
  Future<void> storePreKey(int preKeyId, PreKeyRecord record) async { // TODO:
    final preKeys = jsonDecode((await storage.read(key: preKey)).toString());
    if (preKeys == null) {
      throw InvalidKeyIdException('no prekey found');
    }

    preKeys[preKeyId.toString()] = jsonEncode(record.serialize());

    await storage.write(
      key: preKey,
      value: jsonEncode(preKeys)
    );
  }
}
