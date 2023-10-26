import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert'; // 用於編碼和解碼字串
import 'login_api.dart';

Future<void> onStoreJWTBtnPressed(
    String apiBaseUrl, String acc, String pwd) async {
  print('storeJWTBtnPressed-----------');
  const storage = FlutterSecureStorage();
  final res = await loginAPI(apiBaseUrl, acc, pwd);
  final resBody = jsonDecode(res.body);
  await storage.write(key: 'token', value: resBody['token']);
}
