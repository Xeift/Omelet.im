// ignore_for_file: avoid_print

import './../utils/jwt.dart';
import './../utils/login.dart';
import './../signal_protocol/generate_and_store_key.dart';

// import 'package:socket_io_client/socket_io_client.dart' as io;

Future<void> onLoginBtnPressed(String username, String password,
    Function updateHintMsg, Function catHintMsg) async {
  // if (await isJwtExsist()) {
  //   if (await isJwtValid()) {
  //     print('jwt 存在且有效✅\n應跳轉至聊天室頁面\n');
  //   } else {
  //     print('jwt 存在但無效❌\n應跳轉至登入頁面，提示使用者重新登入\n');
  //     await login(username, password, updateHintMsg, catHintMsg);
  //   }
  // } else {
  //   print('jwt 不存在❌\n該使用者第一次開啟 App，應跳轉至登入頁面並產生公鑰包\n');
  //   await login(username, password, updateHintMsg, catHintMsg);
  //   await generateAndStoreKey();
  // }
}
