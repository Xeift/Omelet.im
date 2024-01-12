import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import './../utils/server_uri.dart';

Future<void> login(String username, String password, Function updateHintMsg,
    Function catHintMsg) async {
  const storage = FlutterSecureStorage();

  final res = await http.post(
    Uri.parse('$serverUri/api/v1/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
        <String, String>{'username': username, 'password': password}),
  );
  final resBody = jsonDecode(res.body);
  await storage.write(key: 'token', value: resBody['token']);
  await storage.write(key: 'uid', value: resBody['data']['uid']);
  await storage.write(key: 'username', value: resBody['data']['username']);
  await storage.write(key: 'email', value: resBody['data']['email']);
  updateHintMsg(
      '歡迎登入，${resBody["data"]["username"]}\n您的id為：${resBody["data"]["uid"]}');
}
