// 登入用

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:omelet/utils/server_uri.dart';

Future<http.Response> loginApi(String username, String password) async {
  final res = await http.post(
    Uri.parse('$serverUri/api/v1/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
        <String, String>{'username': username, 'password': password}),
  );

  return res;
}
