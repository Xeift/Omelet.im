import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as io;

import './../store/safe_msg_store.dart';
import './../debug_utils/debug_config.dart';
import './../main.dart' show socket;

Future<void> onLoginBtnPressed(String serverUri, String username,
    String password, Function updateHintMsg, Function catHintMsg) async {
  final res = await http.post(
    Uri.parse('$serverUri/api/v1/login'),
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
  await writeDebugConfig(serverUri, username, password);
  // ----------------------------------------------------------------
  socket =
      io.io(serverUri, io.OptionBuilder().setTransports(['websocket']).build());

  socket.onConnect((_) async {
    socket.emit('clientReturnJwtToServer', resBody['token']);
    print('backend connected');

    // receive msg
    socket.on('serverForwardMsgToClient', (msg) {
      print('[login] client已接收 $msg');

      catHintMsg('$msg');

      // store received msg
      final safeMsgStore = SafeMsgStore();
      safeMsgStore.writeMsg(msg['sender'], msg);
    });
  });
  // ----------------------------------------------------------------
}
