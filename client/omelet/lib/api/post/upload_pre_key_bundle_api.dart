// 初次使用時上傳 pre key bundle

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:omelet/utils/server_uri.dart';
import 'package:omelet/storage/safe_account_store.dart';

Future<http.Response> uploadPreKeyBundleApi(
    ipkPub, spkPub, spkSig, opkPub) async {
  final token = await loadJwt();

  final res =
      await http.post(Uri.parse('$serverUri/api/v1/upload-pre-key-bundle'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode(<String, String>{
            'ipkPub': ipkPub,
            'spkPub': spkPub,
            'spkSig': spkSig,
            'opkPub': opkPub,
          }));

  return res;
}
