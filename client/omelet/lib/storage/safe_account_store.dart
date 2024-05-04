import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:omelet/signal_protocol/safe_identity_store.dart';

Future<void> changeCurrentActiveAccount(String newUid) async {
  const storage = FlutterSecureStorage();
  await storage.write(key: 'currentActiveAccount', value: newUid);
}

Future<String> loadCurrentActiveAccount() async {
  const storage = FlutterSecureStorage();
  final uid = (await storage.read(key: 'currentActiveAccount')).toString();

  return uid;
}

Future<bool> isCurrentActiveAccountExsist() async {
  const storage = FlutterSecureStorage();
  return (await storage.read(key: 'currentActiveAccount')) != null;
}

Future<void> deletCurrentActiveAccount() async {
  const storage = FlutterSecureStorage();
  await storage.delete(key: 'currentActiveAccount');
}

Future<String> loadUserName() async {
  const storage = FlutterSecureStorage();
  final ourCurrentUid = await loadCurrentActiveAccount();
  final username =
      (await storage.read(key: '${ourCurrentUid}_username')).toString();

  return username;
}

Future<String> loadJwt() async {
  const storage = FlutterSecureStorage();
  final ourCurrentUid = await loadCurrentActiveAccount();
  final token = (await storage.read(key: '${ourCurrentUid}_token')).toString();

  return token;
}

Future<(String, String)> loadJwtAndIpkPub() async {
  const storage = FlutterSecureStorage();
  final ourCurrentUid = await loadCurrentActiveAccount();
  final token = (await storage.read(key: '${ourCurrentUid}_token')).toString();
  final ipkStore = SafeIdentityKeyStore();
  final ipkPub = jsonEncode(
      (await ipkStore.getIdentityKeyPair()).getPublicKey().serialize());
  return (token, ipkPub);
}

Future<String> loadIpkPub() async {
  final ipkStore = SafeIdentityKeyStore();
  final ipkPub = jsonEncode(
      (await ipkStore.getIdentityKeyPair()).getPublicKey().serialize());
  return ipkPub;
}
