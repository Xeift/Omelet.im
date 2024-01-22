import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import './../../utils/server_uri.dart';

Future<http.Response> uploadPreKeyBundleAPI(
    deviceId, ipkPub, spkPub, spkSig, opkPub) async {
  const storage = FlutterSecureStorage();
  final token = await storage.read(key: 'token');
  final res =
      await http.post(Uri.parse('$serverUri/api/v1/upload-pre-key-bundle'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode(<String, String>{
            'deviceId': deviceId,
            'ipkPub': ipkPub,
            'spkPub': spkPub,
            'spkSig': spkSig,
            'opkPub': opkPub,
          }));

  return res;
}
