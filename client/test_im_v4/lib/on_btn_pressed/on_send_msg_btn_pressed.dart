// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:test_im_v4/utils/return_msg_to_server.dart';
import 'package:test_im_v4/signal_protocol/encrypt_msg.dart';
import 'package:test_im_v4/utils/init_socket.dart' show socket;

Future<void> onSendMsgBtnPressed(
    String theirUid, String msgContent, Function updateHintMsg) async {
  print('--------------------------------');
  print('[on_send_msg_btn_pressed.dart] msgContent: $msgContent');
  const storage = FlutterSecureStorage();
  final ourUid = (await storage.read(key: 'uid')).toString();

  // 加密訊息
  final encryptedMsg = await encryptMsg(theirUid, msgContent);
  final ourEncryptedMsg = encryptedMsg['ourEncryptedMsg'];
  final theirEncryptedMsg = encryptedMsg['theirEncryptedMsg'];

  for (var deviceId in ourEncryptedMsg.keys) {
    var singleMsg = await returnMsgToServer(deviceId, ourEncryptedMsg[deviceId],
        ourUid, ourUid, theirUid, 'text', msgContent);
    socket.emit('clientSendMsgToServer', jsonEncode(singleMsg));
  }
  for (var deviceId in theirEncryptedMsg.keys) {
    var singleMsg = await returnMsgToServer(
        deviceId,
        theirEncryptedMsg[deviceId],
        theirUid,
        ourUid,
        theirUid,
        'text',
        msgContent);
    socket.emit('clientSendMsgToServer', jsonEncode(singleMsg));
  }
}
