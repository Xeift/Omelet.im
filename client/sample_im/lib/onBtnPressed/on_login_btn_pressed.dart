import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './../debug_utils/debug_config.dart';

Future<void> onLoginBtnPressed(String apiBaseUrl, String username,
    String password, Function updateHintMsg) async {
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

  await storage.write(key: 'token', value: resBody['token']);
  updateHintMsg(
      '歡迎登入，${resBody["data"]["username"]}\n您的id為：${resBody["data"]["uid"]}');
  await writeDebugConfig(apiBaseUrl, username, password);
  print(await readDebugConfig());
}
