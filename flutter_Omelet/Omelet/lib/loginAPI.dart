import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> loginAPI(
    String _username, String _password) async {
  final res = await http.post(
    Uri.parse(
        'https://5b75-2001-b011-c009-b37c-41b5-4fac-9a6d-b936.ngrok-free.app/api/v1/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
        <String, String>{'username': _username, 'password': _password}),
  );
  return jsonDecode(res.body);
}
