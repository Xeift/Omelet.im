import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:libsignal_protocol_dart/src/invalid_key_id_exception.dart';
import 'package:libsignal_protocol_dart/src/state/signed_pre_key_record.dart';
import 'package:libsignal_protocol_dart/src/state/signed_pre_key_store.dart';

class SafeSpkStore implements SignedPreKeyStore {
  final storage = const FlutterSecureStorage();

  static const String preKey = 'spk';

  @override
  Future<SignedPreKeyRecord> loadSignedPreKey(int signedPreKeyId) async {
    final value = jsonDecode(
        (await storage.read(key: signedPreKeyId.toString())).toString());
    if (value == null) {
      throw InvalidKeyIdException(
          'No such signedprekeyrecord! $signedPreKeyId');
    }
    return SignedPreKeyRecord.fromSerialized(
        Uint8List.fromList(value.cast<int>()));
  }

  @override
  Future<List<SignedPreKeyRecord>> loadSignedPreKeys() async {
    final results = <SignedPreKeyRecord>[];
    final allValues = await storage.readAll();
    for (final value in allValues.values) {
      results.add(SignedPreKeyRecord.fromSerialized(
          Uint8List.fromList(jsonDecode(value).cast<int>())));
    }
    return results;
  }

  @override
  Future<void> storeSignedPreKey(
      int signedPreKeyId, SignedPreKeyRecord record) async {
    await storage.write(
        key: signedPreKeyId.toString(), value: jsonEncode(record.serialize()));
  }

  @override
  Future<bool> containsSignedPreKey(int signedPreKeyId) async =>
      await storage.containsKey(key: signedPreKeyId.toString());

  @override
  Future<void> removeSignedPreKey(int signedPreKeyId) async {
    await storage.delete(key: signedPreKeyId.toString());
  }
}
