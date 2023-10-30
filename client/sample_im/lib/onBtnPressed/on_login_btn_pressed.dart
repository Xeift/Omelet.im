// ignore_for_file: avoid_print

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> onLoginBtnPressed(String apiBaseUrl, String username,
    String password, Function updateHintMsg) async {
  print('test');

  final res = await http.post(
    Uri.parse('$apiBaseUrl/api/v1/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
        <String, String>{'username': username, 'password': password}),
  );
  const storage = FlutterSecureStorage();

  final resBody = jsonDecode(res.body);

  print(resBody);

  await storage.write(key: 'token', value: resBody['token']);
  updateHintMsg('已登入');
}
