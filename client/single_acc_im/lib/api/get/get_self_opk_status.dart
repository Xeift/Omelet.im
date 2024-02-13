import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import './../../utils/server_uri.dart';
import './../../signal_protocol/safe_identity_store.dart';

Future<http.Response> getSelfOpkStatus() async {
  const storage = FlutterSecureStorage();
  final token = await storage.read(key: 'token');
  final ipkStore = SafeIdentityKeyStore();
  final ipkPub = jsonEncode(
      (await ipkStore.getIdentityKeyPair()).getPublicKey().serialize());
  print('[get_self_opk_status.dart] $ipkPub');

  final res = await http.get(
      Uri.parse('$serverUri/api/v1/get-self-opk-status?ipkPub=$ipkPub'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      });

  return res;
}
