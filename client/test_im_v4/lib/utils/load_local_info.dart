import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:test_im_v4/signal_protocol/safe_identity_store.dart';

const serverUri = 'https://e1b7-125-227-227-205.ngrok-free.app';
const username = 'np';
const password = 'a';

// const serverUri = 'http://localhost:3000';
// const username = 'xeift';
// const password = 'a';

Future<String> loadUid() async {
  const storage = FlutterSecureStorage();
  final uid = (await storage.read(key: 'uid')).toString();

  return uid;
}

Future<String> loadJwt() async {
  const storage = FlutterSecureStorage();
  final token = (await storage.read(key: 'token')).toString();

  return token;
}

Future<(String, String)> loadJwtAndIpkPub() async {
  const storage = FlutterSecureStorage();
  final token = (await storage.read(key: 'token')).toString();
  final ipkStore = SafeIdentityKeyStore();
  final ipkPub = jsonEncode(
      (await ipkStore.getIdentityKeyPair()).getPublicKey().serialize());

  return (token, ipkPub);
}
