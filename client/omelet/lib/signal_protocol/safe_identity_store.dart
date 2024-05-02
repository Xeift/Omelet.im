// ignore_for_file: implementation_imports

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:libsignal_protocol_dart/src/eq.dart';
import 'package:libsignal_protocol_dart/src/identity_key.dart';
import 'package:libsignal_protocol_dart/src/identity_key_pair.dart';
import 'package:libsignal_protocol_dart/src/signal_protocol_address.dart';
import 'package:libsignal_protocol_dart/src/state/identity_key_store.dart';
import 'package:omelet/storage/safe_account_store.dart';

class SafeIdentityKeyStore implements IdentityKeyStore {
  static const storage = FlutterSecureStorage();

  @override
  Future<IdentityKey?> getIdentity(SignalProtocolAddress address) async {
    final ourCurrentUid = await loadCurrentActiveAccount();
    final iks = jsonDecode(
        (await storage.read(key: '${ourCurrentUid}_othersIpk')).toString());
    if (iks == null) {
      return null;
    }

    final singleIK = iks[address.toString()];
    if (singleIK == null) {
      return null;
    }

    return IdentityKey.fromBytes(
        Uint8List.fromList(jsonDecode(singleIK).cast<int>().toList()), 0);
  }

  @override
  Future<IdentityKeyPair> getIdentityKeyPair() async {
    final ourCurrentUid = await loadCurrentActiveAccount();
    return IdentityKeyPair.fromSerialized(Uint8List.fromList(jsonDecode(
            (await storage.read(key: '${ourCurrentUid}_selfIpk')).toString())
        .cast<int>()
        .toList()));
  }

  @override
  Future<int> getLocalRegistrationId() async {
    final ourCurrentUid = await loadCurrentActiveAccount();
    return int.parse(
        (await storage.read(key: '${ourCurrentUid}_localRegistrationId'))
            .toString());
  }

  @override
  Future<bool> isTrustedIdentity(SignalProtocolAddress address,
      IdentityKey? identityKey, Direction? direction) async {
    final trusted = await getIdentity(address);
    if (identityKey == null) {
      return false;
    }
    return trusted == null || eq(trusted.serialize(), identityKey.serialize());
  }

  @override
  Future<bool> saveIdentity(
      SignalProtocolAddress address, IdentityKey? identityKey) async {
    final ourCurrentUid = await loadCurrentActiveAccount();
    Map<String, dynamic> identityKeys = jsonDecode(
            (await storage.read(key: '${ourCurrentUid}_othersIpk'))
                .toString()) ??
        {};

    final existing = identityKeys[address.toString()];
    if (identityKey == null) {
      return false;
    }
    if (identityKey.serialize() != existing) {
      identityKeys[address.toString()] = jsonEncode(identityKey.serialize());
      final ourUid = await loadCurrentActiveAccount();
      await storage.write(
          key: '${ourUid}_othersIpk', value: jsonEncode(identityKeys));
      return true;
    } else {
      return false;
    }
  }

  Future<bool> saveIdentityKeyPair(
      IdentityKeyPair identityKeyPair, int localRegistrationId) async {
    final ourUid = await loadCurrentActiveAccount();
    await storage.write(
        key: '${ourUid}_selfIpk',
        value: jsonEncode(identityKeyPair.serialize()));
    await storage.write(
        key: '${ourUid}_localRegistrationId',
        value: localRegistrationId.toString());
    return true;
  }
}
