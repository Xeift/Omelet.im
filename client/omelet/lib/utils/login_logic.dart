// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import './../api/post/login_api.dart';

Future<int> loginLogic(
  String username,
  String password,
) async {
  const storage = FlutterSecureStorage();

  final res = await loginAPI(username, password);
  final resBody = jsonDecode(res.body);
  final statusCode = res.statusCode;

  print('[login_logic.dart] 登入 API 回應內容：$resBody');
  print('[login_logic.dart] 登入 API 狀態碼：$statusCode');

  if (statusCode == 200) {
    await storage.write(key: 'token', value: resBody['token']);
    await storage.write(key: 'uid', value: resBody['data']['uid']);
    await storage.write(key: 'username', value: resBody['data']['username']);
    await storage.write(key: 'email', value: resBody['data']['email']);

    print('[main.dart] 目前儲存空間所有內容：${await storage.readAll()}');
  }
  return statusCode;
}
