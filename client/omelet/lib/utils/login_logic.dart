// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

import '../pages/chat_list_page.dart';
import './../componets/alert/alert_msg.dart';

import './../api/post/login_api.dart';

Future<void> loginLogic(
    String username, String password, BuildContext context) async {
  const storage = FlutterSecureStorage();

  final res = await loginAPI(username, password);
  final resBody = jsonDecode(res.body);
  final statusCode = res.statusCode;

  print('[main.dart] 登入 API 回應內容：$resBody');
  print('[main.dart] 登入 API 狀態碼：$statusCode');

  if (statusCode == 200) {
    await storage.write(key: 'token', value: resBody['token']);
    await storage.write(key: 'uid', value: resBody['data']['uid']);
    await storage.write(key: 'username', value: resBody['data']['username']);
    await storage.write(key: 'email', value: resBody['data']['email']);

    print('[main.dart] 目前儲存空間所有內容：${await storage.readAll()}');

    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const ChatListPage()));
  } else if (statusCode == 401) {
    // 帳號密碼錯誤
    LoginEorroMsg(context, '帳號密碼錯誤');
  } else if (statusCode == 422) {
    // 帳號密碼為空
    LoginEorroMsg(context, '請輸入帳號密碼');
  } else if (statusCode == 429) {
    // 速率限制，請求次數過多（5分鐘內超過10次）
    LoginEorroMsg(context, '請稍候再重新輸入');
  } else if (statusCode == 500) {
    // 後端其他錯誤
    LoginEorroMsg(context, '伺服器預期外錯誤');
  }
}
