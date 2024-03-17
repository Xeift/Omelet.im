// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:omelet/api/post/login_api.dart';

Future<void> login(String username, String password) async {
  const storage = FlutterSecureStorage();

  final res = jsonDecode((await loginApi(username, password)).body);
  await storage.write(key: 'token', value: res['token']);
  await storage.write(key: 'uid', value: res['data']['uid']);
  await storage.write(key: 'username', value: res['data']['username']);
  await storage.write(key: 'email', value: res['data']['email']);

  final data = res["data"];
  print('[login.dart]${data["username"]}\n您的id為：${data["uid"]}');
}
