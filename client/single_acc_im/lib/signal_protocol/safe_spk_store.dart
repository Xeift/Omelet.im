// ignore_for_file: implementation_imports

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:libsignal_protocol_dart/src/invalid_key_id_exception.dart';
import 'package:libsignal_protocol_dart/src/state/signed_pre_key_record.dart';
import 'package:libsignal_protocol_dart/src/state/signed_pre_key_store.dart';

class SafeSpkStore implements SignedPreKeyStore {
  final storage = const FlutterSecureStorage();

  @override
  Future<SignedPreKeyRecord> loadSignedPreKey(int signedPreKeyId) async {
    final spks = jsonDecode((await storage.read(key: 'selfSpk')).toString());
    if (spks == null) {
      throw InvalidKeyIdException('no signedprekeyrecord found');
    }

    final singleSPK = spks[signedPreKeyId.toString()];
    if (singleSPK == null) {
      throw InvalidKeyIdException(
          'No such signedprekeyrecord! $signedPreKeyId');
    }
    return SignedPreKeyRecord.fromSerialized(
        Uint8List.fromList(jsonDecode(singleSPK).cast<int>()));
  }

  @override
  Future<List<SignedPreKeyRecord>> loadSignedPreKeys() async {
    final results = <SignedPreKeyRecord>[];
    final spks = jsonDecode((await storage.read(key: 'selfSpk')).toString());
    if (spks == null) {
      throw InvalidKeyIdException('no signedprekeyrecord found');
    }
    for (final value in spks.values) {
      results.add(SignedPreKeyRecord.fromSerialized(
          Uint8List.fromList(jsonDecode(value).cast<int>())));
    }
    return results;
  }

  @override
  Future<void> storeSignedPreKey(
      int signedPreKeyId, SignedPreKeyRecord record) async {
    Map<String, dynamic> signedPreKeys =
        jsonDecode((await storage.read(key: 'selfSpk')).toString()) ?? {};

    signedPreKeys[signedPreKeyId.toString()] = jsonEncode(record.serialize());

    await storage.write(key: 'selfSpk', value: jsonEncode(signedPreKeys));
  }

  @override
  Future<bool> containsSignedPreKey(int signedPreKeyId) async {
    final signedPreKeys =
        jsonDecode((await storage.read(key: 'selfSpk')).toString());
    if (signedPreKeys == null) {
      throw InvalidKeyIdException('no signedprekeyrecord found');
    }

    final singleSignedPreKey = signedPreKeys[signedPreKeyId.toString()];

    return singleSignedPreKey != null;
  }

  @override
  Future<void> removeSignedPreKey(int signedPreKeyId) async {
    var signedPreKeys =
        jsonDecode((await storage.read(key: 'selfSpk')).toString());
    if (signedPreKeys == null) {
      throw InvalidKeyIdException('no signedprekeyrecord found');
    }

    signedPreKeys.remove(signedPreKeyId.toString());

    await storage.write(key: 'selfSpk', value: jsonEncode(signedPreKeys));
  }
}
