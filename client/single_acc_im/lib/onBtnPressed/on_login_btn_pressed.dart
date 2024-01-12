// ignore_for_file: avoid_print

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// import 'package:socket_io_client/socket_io_client.dart' as io;
const storage = FlutterSecureStorage();

Future<void> onLoginBtnPressed(String serverUri, String username,
    String password, Function updateHintMsg, Function catHintMsg) async {
  // if (await isJwtExsist()) {
  //   print('jwt exsist!😎');
  // } else {
  //   print('jwt not exsist!😂');
  // }

  Future<void> login() async {
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
    updateHintMsg(
        '歡迎登入，${resBody["data"]["username"]}\n您的id為：${resBody["data"]["uid"]}');
  }

  await login();
}

// Future<bool> isJwtExsist() async {
//   return (await storage.read(key: 'token')) != null;
// }
