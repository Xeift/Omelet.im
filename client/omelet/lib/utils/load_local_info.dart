import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:omelet/signal_protocol/safe_identity_store.dart';

const serverUri = 'https://e9a5-60-249-247-100.ngrok-free.app';
// const serverUri = 'http://localhost:3000';

Future<String> loadUid() async {
  const storage = FlutterSecureStorage();
  final uid = (await storage.read(key: 'uid')).toString();

  return uid;
}

Future<String> loadUserName() async {
  const storage = FlutterSecureStorage();
  final username = (await storage.read(key: 'username')).toString();

  return username;
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
