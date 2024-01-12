// ignore_for_file: avoid_print

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './../utils/jwt.dart';
import './../utils/login.dart';

// import 'package:socket_io_client/socket_io_client.dart' as io;
const storage = FlutterSecureStorage();

Future<void> onLoginBtnPressed(String serverUri, String username,
    String password, Function updateHintMsg, Function catHintMsg) async {
  if (await isJwtExsist()) {
    print('jwt exsist!✅');
    await isJwtValid(serverUri, updateHintMsg);
  } else {
    print('jwt not exsist!❌');
  }

  await login(serverUri, username, password, updateHintMsg, catHintMsg);
}
