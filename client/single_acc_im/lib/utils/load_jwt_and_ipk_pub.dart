import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import './../../signal_protocol/safe_identity_store.dart';

Future<(String, String)> loadJwtAndIpkPub() async {
  const storage = FlutterSecureStorage();
  final token = (await storage.read(key: 'token')).toString();
  final ipkStore = SafeIdentityKeyStore();
  final ipkPub = jsonEncode(
      (await ipkStore.getIdentityKeyPair()).getPublicKey().serialize());

  return (token, ipkPub);
}
