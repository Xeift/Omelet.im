// ignore_for_file: implementation_imports, avoid_print

import 'dart:core';

import 'package:libsignal_protocol_dart/src/identity_key.dart';
import 'package:libsignal_protocol_dart/src/identity_key_pair.dart';
import 'package:libsignal_protocol_dart/src/signal_protocol_address.dart';
import 'package:libsignal_protocol_dart/src/state/identity_key_store.dart';
import 'package:libsignal_protocol_dart/src/state/pre_key_record.dart';
import 'package:libsignal_protocol_dart/src/state/session_record.dart';
import 'package:libsignal_protocol_dart/src/state/signal_protocol_store.dart';
import 'package:libsignal_protocol_dart/src/state/signed_pre_key_record.dart';

import 'package:test_im_v4/signal_protocol/safe_identity_store.dart';
import 'package:test_im_v4/signal_protocol/safe_spk_store.dart';
import 'package:test_im_v4/signal_protocol/safe_opk_store.dart';
import 'package:test_im_v4/signal_protocol/safe_session_store.dart';

class SafeSignalProtocolStore implements SignalProtocolStore {
  final safeIpkStore = SafeIdentityKeyStore();
  final safeOpkStore = SafeOpkStore();
  final safeSessionStore = SafeSessionStore();
  final safeSpkStore = SafeSpkStore();

  @override
  Future<IdentityKeyPair> getIdentityKeyPair() async =>
      safeIpkStore.getIdentityKeyPair();

  @override
  Future<int> getLocalRegistrationId() async =>
      safeIpkStore.getLocalRegistrationId();

  @override
  Future<bool> saveIdentity(
          SignalProtocolAddress address, IdentityKey? identityKey) async =>
      safeIpkStore.saveIdentity(address, identityKey);

  @override
  Future<bool> isTrustedIdentity(SignalProtocolAddress address,
          IdentityKey? identityKey, Direction direction) async =>
      safeIpkStore.isTrustedIdentity(address, identityKey, direction);

  @override
  Future<IdentityKey?> getIdentity(SignalProtocolAddress address) async =>
      safeIpkStore.getIdentity(address);

  @override
  Future<PreKeyRecord> loadPreKey(int preKeyId) async =>
      safeOpkStore.loadPreKey(preKeyId);

  @override
  Future<void> storePreKey(int preKeyId, PreKeyRecord record) async {
    await safeOpkStore.storePreKey(preKeyId, record);
  }

  @override
  Future<bool> containsPreKey(int preKeyId) async =>
      safeOpkStore.containsPreKey(preKeyId);

  @override
  Future<void> removePreKey(int preKeyId) async {
    await safeOpkStore.removePreKey(preKeyId);
  }

  @override
  Future<SessionRecord> loadSession(SignalProtocolAddress address) async =>
      safeSessionStore.loadSession(address);

  @override
  Future<List<int>> getSubDeviceSessions(String name) async =>
      safeSessionStore.getSubDeviceSessions(name);

  @override
  Future<void> storeSession(
      SignalProtocolAddress address, SessionRecord record) async {
    await safeSessionStore.storeSession(address, record);
  }

  @override
  Future<bool> containsSession(SignalProtocolAddress address) async =>
      safeSessionStore.containsSession(address);

  @override
  Future<void> deleteSession(SignalProtocolAddress address) async {
    await safeSessionStore.deleteSession(address);
  }

  @override
  Future<void> deleteAllSessions(String name) async {
    await safeSessionStore.deleteAllSessions(name);
  }

  @override
  Future<SignedPreKeyRecord> loadSignedPreKey(int signedPreKeyId) async =>
      safeSpkStore.loadSignedPreKey(signedPreKeyId);

  @override
  Future<List<SignedPreKeyRecord>> loadSignedPreKeys() async =>
      safeSpkStore.loadSignedPreKeys();

  @override
  Future<void> storeSignedPreKey(
      int signedPreKeyId, SignedPreKeyRecord record) async {
    await safeSpkStore.storeSignedPreKey(signedPreKeyId, record);
  }

  @override
  Future<bool> containsSignedPreKey(int signedPreKeyId) async =>
      safeSpkStore.containsSignedPreKey(signedPreKeyId);

  @override
  Future<void> removeSignedPreKey(int signedPreKeyId) async {
    await safeSpkStore.removeSignedPreKey(signedPreKeyId);
  }
}
