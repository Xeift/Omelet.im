// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:omelet/api/post/login_api.dart';

Future<(int, dynamic)> login(String username, String password) async {
  const storage = FlutterSecureStorage();

  final res = await loginApi(username, password);
  final resBody = jsonDecode(res.body);
  final data = resBody['data'];
  final statusCode = res.statusCode;

  await storage.write(key: 'token', value: resBody['token']);
  await storage.write(key: 'uid', value: resBody['data']['uid']);
  await storage.write(key: 'username', value: resBody['data']['username']);
  await storage.write(key: 'email', value: resBody['data']['email']);

  print('[login.dart]${data["username"]}\n您的id為：${data["uid"]}');

  return (statusCode, data);
}
