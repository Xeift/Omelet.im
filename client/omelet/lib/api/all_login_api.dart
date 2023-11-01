// // ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'dart:convert';

Future<http.Response> loginAPI(String _username, String _password) async {
  final res = await http.post(
    Uri.parse('http://localhost:3000/api/v1/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
        <String, String>{'username': _username, 'password': _password}),
  );
  return res;
}

Future<http.Response> forgetemailAPI(String _forgetEamil) async {
  final forgetemailres = await http.post(
    Uri.parse('http://localhost:3000/api/v1/reset-password'),
    headers: <String,String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
        <String,String>{'email':_forgetEamil}),
  );
  return forgetemailres;
}