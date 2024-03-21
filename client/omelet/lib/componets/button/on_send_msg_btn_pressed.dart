// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:omelet/utils/return_msg_to_server.dart';
import 'package:omelet/signal_protocol/encrypt_msg.dart';
import 'package:omelet/pages/login_signup/loading_page.dart' show socket;
import 'package:omelet/utils/load_local_info.dart';
import 'package:omelet/message/safe_msg_store.dart';

Future<void> onSendMsgBtnPressed(String theirUid, String msgContent) async {
  print('--------------------------------');
  print('[on_send_msg_btn_pressed.dart] msgContent: $msgContent');
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
  final ourEncryptedMsg = encryptedMsg['ourMsgInfo'];
  final theirEncryptedMsg = encryptedMsg['theirMsgInfo'];

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
