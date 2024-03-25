import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:omelet/utils/load_local_info.dart';

Future<http.Response> signUpSendMailApi(
    String email, String username, String password) async {
  final res = await http.post(
    Uri.parse('$serverUri/api/v1/register/send-mail'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'username': username,
      'password': password
    }),
  );

  return res;
}
