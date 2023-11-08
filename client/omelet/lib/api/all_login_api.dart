// // ignore_for_file: avoid_print
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<http.Response> loginAPI(String _userName, String _passWord) async {
  final res = await http.post(
    Uri.parse('http://10.0.2.2:3000/api/v1/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
        <String, String>{'username': _userName, 'password': _passWord}),
  );
  return res;
}

Future<http.Response> forgetemailAPI(String _forgetEamil) async {
  final forgetemailres = await http.post(
    Uri.parse('http://10.0.2.2:3000/api/v1/reset-password/send-mail'),
    headers: <String,String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
        <String,String>{'email':_forgetEamil}),
  );
  return forgetemailres;
}
Future<http.Response> signUpAPI(String _signUpEmail,String _signUpName,String _signUpPassword) async {
  final signUpData = await http.post(
    Uri.parse('http://10.0.2.2:3000/api/v1/register/send-mail'),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
        <String,String>{'email': _signUpEmail,'username': _signUpName,'password':_signUpPassword}),
  );
  return signUpData;
}