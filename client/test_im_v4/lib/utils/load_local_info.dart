import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:test_im_v4/signal_protocol/safe_identity_store.dart';

// const serverUri = 'https://e9a5-60-249-247-100.ngrok-free.app';
// const username = 'np';
// const password = 'a';

// const serverUri = 'https://7eb3-60-249-247-100.ngrok-free.app';
// const username = 'xeift';
// const password = 'a';

// const serverUri = 'http://localhost:3000';
// const username = 'khusc';
// const password = 'a';

const serverUri =
    'https://91ac-2001-b011-c009-183c-add8-7063-a217-52db.ngrok-free.app';
const username = 'elpma';
const password = 'a';

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
