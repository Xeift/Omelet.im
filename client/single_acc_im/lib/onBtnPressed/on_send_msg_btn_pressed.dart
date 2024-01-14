import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './../store/safe_msg_store.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import './../utils/download_pre_key_bundle.dart';

// ignore_for_file: avoid_print
// import '../main.dart' show socket;

Future<void> onSendMsgBtnPressed(
    String receiverId, String msgContent, Function updateHintMsg) async {
  const storage = FlutterSecureStorage();
  final token = await storage.read(key: 'token');
  final res = await downloadPreKeyBundleAPI(receiverId);
  print(res.body);

  // print('[on_send_msg_btn_pressed.dart] $receiverId $msgContent');

  // final currentTimestamp = DateTime.now().millisecondsSinceEpoch.toString();

  // // sent msg
  // socket.emit('clientSendMsgToServer', {
  //   'token': token,
  //   'timestamp': currentTimestamp,
  //   'type': 'text',
  //   'receiver': receiverId,
  //   'content': msgContent
  // });

  // // store msg sent
  // final safeMsgStore = SafeMsgStore();
  // safeMsgStore.writeMsg(receiverId, {
  //   'timestamp': currentTimestamp,
  //   'type': 'text',
  //   'receiver': receiverId,
  //   'sender': 'self',
  //   'content': msgContent
  // });

  // socket.onDisconnect((_) => print('disconnect'));

  // updateHintMsg('接收者 id: $receiverId\n發送內容： $msgContent');
}
