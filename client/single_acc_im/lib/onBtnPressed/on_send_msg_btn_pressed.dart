import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import './../store/safe_msg_store.dart';
import './../utils/download_pre_key_bundle.dart';

// ignore_for_file: avoid_print
// import '../main.dart' show socket;

Future<void> onSendMsgBtnPressed(
    String receiverId, String msgContent, Function updateHintMsg) async {
  const storage = FlutterSecureStorage();
  final token = await storage.read(key: 'token');
  final res = await downloadPreKeyBundleAPI(receiverId);
  final preKeyBundle = jsonDecode(res.body)['data'];
  const opkId = '5';

  final ipkPub = IdentityKey.fromBytes(
      Uint8List.fromList(
          jsonDecode(preKeyBundle['ipkPub']).cast<int>().toList()),
      0);
  final spkPub = Curve.decodePoint(
      Uint8List.fromList(
          jsonDecode(preKeyBundle['spkPub']).cast<int>().toList()),
      0);
  final spkSig = Uint8List.fromList(
      jsonDecode(preKeyBundle['spkSig']).cast<int>().toList());
  final opkPub = Curve.decodePoint(
      Uint8List.fromList(
          (jsonDecode(preKeyBundle['opkPub'][opkId])).cast<int>().toList()),
      0);

  print(opkPub);
  print(opkPub.runtimeType);

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
