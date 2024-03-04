import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import './../api/post/login_api.dart';

Future<void> login(String username, String password, Function updateHintMsg,
    Function catHintMsg) async {
  const storage = FlutterSecureStorage();

  final res = jsonDecode((await loginAPI(username, password)).body); // 1
  await storage.write(key: 'token', value: res['token']);
  await storage.write(key: 'uid', value: res['data']['uid']);
  await storage.write(key: 'username', value: res['data']['username']);
  await storage.write(key: 'email', value: res['data']['email']);
  updateHintMsg('歡迎登入，${res["data"]["username"]}\n您的id為：${res["data"]["uid"]}');
}
