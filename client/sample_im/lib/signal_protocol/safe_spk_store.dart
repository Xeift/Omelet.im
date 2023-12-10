import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:libsignal_protocol_dart/src/invalid_key_id_exception.dart';
import 'package:libsignal_protocol_dart/src/state/signed_pre_key_record.dart';
import 'package:libsignal_protocol_dart/src/state/signed_pre_key_store.dart';

class SafeSpkStore implements SignedPreKeyStore {
  // Create a FlutterSecureStorage object
  final _storage = const FlutterSecureStorage();

  @override
  Future<SignedPreKeyRecord> loadSignedPreKey(int signedPreKeyId) async {
    // Read the value from the storage with the key
    final value = jsonDecode(
        (await _storage.read(key: signedPreKeyId.toString())).toString());
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
    // Read all the values from the storage
    final allValues = await _storage.readAll();
    for (final value in allValues.values) {
      results.add(SignedPreKeyRecord.fromSerialized(
          Uint8List.fromList(value.codeUnits)));
    }
    return results;
  }

  @override
  Future<void> storeSignedPreKey(
      int signedPreKeyId, SignedPreKeyRecord record) async {
    // Write the value to the storage with the key
    await _storage.write(
        key: signedPreKeyId.toString(), value: jsonEncode(record.serialize()));
  }

  @override
  Future<bool> containsSignedPreKey(int signedPreKeyId) async =>
      // Check if the storage contains the key
      await _storage.containsKey(key: signedPreKeyId.toString());

  @override
  Future<void> removeSignedPreKey(int signedPreKeyId) async {
    // Delete the value from the storage with the key
    await _storage.delete(key: signedPreKeyId.toString());
  }
}
