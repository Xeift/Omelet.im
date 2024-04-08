import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:omelet/signal_protocol/safe_identity_store.dart';

// const serverUri = 'https://221f-125-227-227-205.ngrok-free.app';
// const serverUri = 'http://localhost:3000';
const serverUri = 'https://omelet.im:8443';
// const serverUri = 'http://omelet.im:443';
// const serverUri =
//     'http://ec2-13-208-190-21.ap-northeast-3.compute.amazonaws.com:8880';

Future<void> changeCurrentActiveAccount(String newUid) async {
  const storage = FlutterSecureStorage();
  await storage.write(key: 'currentActiveAccount', value: newUid);
}

Future<String> loadCurrentActiveAccount() async {
  const storage = FlutterSecureStorage();
  final uid = (await storage.read(key: 'currentActiveAccount')).toString();

  return uid;
}

Future<String> loadUid() async {
  const storage = FlutterSecureStorage();
  final ourCurrentUid = await loadCurrentActiveAccount();
  final uid = (await storage.read(key: '${ourCurrentUid}_uid')).toString();

  return uid;
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
