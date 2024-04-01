// ignore_for_file: implementation_imports

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:libsignal_protocol_dart/src/invalid_key_id_exception.dart';
import 'package:libsignal_protocol_dart/src/state/signed_pre_key_record.dart';
import 'package:libsignal_protocol_dart/src/state/signed_pre_key_store.dart';
import 'package:omelet/utils/load_local_info.dart';

class SafeSpkStore implements SignedPreKeyStore {
  final storage = const FlutterSecureStorage();

  @override
  Future<SignedPreKeyRecord> loadSignedPreKey(int signedPreKeyId) async {
    final ourCurrentUid = await loadCurrentActiveAccount();
    final spks = jsonDecode(
        (await storage.read(key: '${ourCurrentUid}_selfSpk')).toString());
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
    final ourCurrentUid = await loadCurrentActiveAccount();
    final spks = jsonDecode(
        (await storage.read(key: '${ourCurrentUid}_selfSpk')).toString());
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
    final ourCurrentUid = await loadCurrentActiveAccount();
    Map<String, dynamic> signedPreKeys = jsonDecode(
            (await storage.read(key: '${ourCurrentUid}_selfSpk')).toString()) ??
        {};

    signedPreKeys[signedPreKeyId.toString()] = jsonEncode(record.serialize());

    final ourUid = await loadCurrentActiveAccount();
    await storage.write(
        key: '${ourUid}_selfSpk', value: jsonEncode(signedPreKeys));
  }

  @override
  Future<bool> containsSignedPreKey(int signedPreKeyId) async {
    final ourCurrentUid = await loadCurrentActiveAccount();
    final signedPreKeys = jsonDecode(
        (await storage.read(key: '${ourCurrentUid}_selfSpk')).toString());
    if (signedPreKeys == null) {
      throw InvalidKeyIdException('no signedprekeyrecord found');
    }

    final singleSignedPreKey = signedPreKeys[signedPreKeyId.toString()];

    return singleSignedPreKey != null;
  }

  @override
  Future<void> removeSignedPreKey(int signedPreKeyId) async {
    final ourCurrentUid = await loadCurrentActiveAccount();
    var signedPreKeys = jsonDecode(
        (await storage.read(key: '${ourCurrentUid}_selfSpk')).toString());
    if (signedPreKeys == null) {
      throw InvalidKeyIdException('no signedprekeyrecord found');
    }

    signedPreKeys.remove(signedPreKeyId.toString());
    final ourUid = await loadCurrentActiveAccount();
    await storage.write(
        key: '${ourUid}_selfSpk', value: jsonEncode(signedPreKeys));
  }
}
