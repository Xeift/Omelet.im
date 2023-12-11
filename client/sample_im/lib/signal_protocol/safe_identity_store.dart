import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:libsignal_protocol_dart/src/eq.dart';
import 'package:libsignal_protocol_dart/src/identity_key.dart';
import 'package:libsignal_protocol_dart/src/identity_key_pair.dart';
import 'package:libsignal_protocol_dart/src/signal_protocol_address.dart';
import 'package:libsignal_protocol_dart/src/state/identity_key_store.dart';

class SafeIdentityKeyStore implements IdentityKeyStore {
  SafeIdentityKeyStore(this.identityKeyPair, this.localRegistrationId);

  final storage = const FlutterSecureStorage();
  static const String fssKey = 'ik';

  final IdentityKeyPair identityKeyPair;
  final int localRegistrationId;

  @override
  Future<IdentityKey?> getIdentity(SignalProtocolAddress address) async {
    final iks = jsonDecode((await storage.read(key: fssKey)).toString());
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
  Future<IdentityKeyPair> getIdentityKeyPair() async => identityKeyPair;

  @override
  Future<int> getLocalRegistrationId() async => localRegistrationId;

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
    print('😎😋😎😋😊😉😉😉start func');
    print('💜💙');
    print(address);
    print('💜💙');
    Map<String, dynamic> identityKeys =
        jsonDecode((await storage.read(key: fssKey)).toString()) ?? {};

    final existing = identityKeys[address.toString()];
    if (identityKey == null) {
      return false;
    }
    if (identityKey.serialize() != existing) {
      print(identityKeys);
      identityKeys[address.toString()] = jsonEncode(identityKey.serialize());
      await storage.write(key: fssKey, value: jsonEncode(identityKeys));
      print('write ik: ${jsonEncode(identityKeys)}');
      print('code 2');
      final aaa = await storage.read(key: fssKey);
      print('read ik: $aaa');

      print('😎😋😎😋😊😉😉😉end func\n');

      return true;
    } else {
      print('code 3');
      return false;
    }
  }
}
