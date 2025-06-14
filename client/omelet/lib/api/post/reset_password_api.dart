// 發送重置密碼的 Email

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:omelet/utils/server_uri.dart';

Future<http.Response> resetPasswordSendMailApi(String email) async {
  final res = await http.post(
    Uri.parse('$serverUri/api/v1/reset-password/send-mail'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'email': email}),
  );

  return res;
}
