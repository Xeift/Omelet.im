import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './../store/safe_msg_store.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import './../debug_utils/debug_config.dart';
// ignore_for_file: avoid_print

Future<void> onSendMsgBtnPressed(
    String receiverId, String msgContent, Function updateHintMsg) async {
  final serverUri = (await readDebugConfig())['serverUri'];

  print('[on_send_msg_btn_pressed.dart] $receiverId $msgContent');

  io.Socket socket =
      io.io(serverUri, io.OptionBuilder().setTransports(['websocket']).build());

  const storage = FlutterSecureStorage();
  final token = await storage.read(key: 'token');

  socket.onConnect((_) async {
    print(token);
    socket.emit('clientReturnJwtToServer', token);
    print('backend connected');
  });

  // sent msg
  socket.emit('clientSendMsgToServer', {
    'token': token,
    'timestamp': '1694867028600',
    'type': 'text',
    'receiver': receiverId,
    'content': msgContent
  });

  // store msg sent
  final safeMsgStore = SafeMsgStore();
  safeMsgStore.writeMsg(receiverId, {
    'timestamp': '1694867028600',
    'type': 'text',
    'receiver': receiverId,
    'sender': 'self',
    'content': msgContent
  });

  socket.onDisconnect((_) => print('disconnect'));

  // receive msg
  socket.on('serverForwardMsgToClient', (msg) {
    print('client已接收 $msg');
    updateHintMsg('client已接收 $msg');

    // store received msg
    final safeMsgStore = SafeMsgStore();
    safeMsgStore.writeMsg(msg['sender'], msg);
  });

  updateHintMsg('接收者 id: $receiverId\n發送內容： $msgContent');
}
