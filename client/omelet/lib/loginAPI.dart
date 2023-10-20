import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> loginAPI(
    String _username, String _password) async {
  final res = await http.post(
    Uri.parse('http://localhost:3000/api/v1/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
        <String, String>{'username': _username, 'password': _password}),
  );
  print(res.statusCode);
  return jsonDecode(res.body);
}
