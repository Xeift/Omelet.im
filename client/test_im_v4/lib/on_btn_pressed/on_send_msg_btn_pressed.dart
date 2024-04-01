// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:test_im_v4/utils/return_msg_to_server.dart';
import 'package:test_im_v4/signal_protocol/encrypt_msg.dart';
import 'package:test_im_v4/utils/init_socket.dart' show socket;
import 'package:test_im_v4/utils/load_local_info.dart';
import 'package:test_im_v4/message/safe_msg_store.dart';

Future<void> onSendMsgBtnPressed(
    String theirUid, String msgContent, Function updateHintMsg) async {
  print('--------------------------------');
  print('[on_send_msg_btn_pressed.dart] 訊息明文: $msgContent');
  final ourUid = await loadUid();
  final currentTimestamp = DateTime.now().millisecondsSinceEpoch.toString();

  // 將發送的訊息儲存到本地
  final safeMsgStore = SafeMsgStore();
  await safeMsgStore.writeMsg(theirUid, {
    'timestamp': currentTimestamp,
    'type': 'text',
    'sender': ourUid,
    'receiver': theirUid,
    'content': msgContent,
  });

  // 加密訊息
  final encryptedMsg = await encryptMsg(theirUid, msgContent);
  final ourEncryptedMsg = encryptedMsg['ourEncryptedMsg'];
  final theirEncryptedMsg = encryptedMsg['theirEncryptedMsg'];

  // 將加密過的訊息傳回 Server
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
