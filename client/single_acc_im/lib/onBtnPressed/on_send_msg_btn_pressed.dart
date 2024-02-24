// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import './../main.dart' show socket;
import './../message/safe_msg_store.dart';
import './../signal_protocol/encrypt_msg.dart';

Future<void> onSendMsgBtnPressed(
    String theirUid, String msgContent, Function updateHintMsg) async {
  print('--------------------------------');
  const storage = FlutterSecureStorage();
  final ourUid = (await storage.read(key: 'uid')).toString();
  final currentTimestamp = DateTime.now().millisecondsSinceEpoch.toString();

  // 加密訊息
  final msgInfo = await encryptMsg(theirUid, msgContent, updateHintMsg);
  final ourMsgInfo = msgInfo['ourMsgInfo'];
  final theirMsgInfo = msgInfo['theirMsgInfo'];

  print('🎈🎈🎈🎈🎈🎈🎈🎈🎈🎈🎈🎈');
  print('[on_send_msg_btn_pressed.dart] msgInfo👉: $msgInfo');
  print('[on_send_msg_btn_pressed.dart] msgInfo👉: $ourMsgInfo');
  print('[on_send_msg_btn_pressed.dart] msgInfo👉: $theirMsgInfo');
  print('🎈🎈🎈🎈🎈🎈🎈🎈🎈🎈🎈🎈');

  Future<Map<String, dynamic>> returnMsgToServer(
      deviceId, singleMsgInfo, receiverUid) async {
    final (cihertext, isPreKeySignalMessage, spkId, opkId) = singleMsgInfo;

    print('🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃');
    print(cihertext);
    print(isPreKeySignalMessage);
    print(spkId);
    print(opkId);
    print('🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃\n');

    // 將發送的訊息儲存到本地
    final safeMsgStore = SafeMsgStore();
    safeMsgStore.writeMsg(theirUid, {
      'timestamp': currentTimestamp,
      'type': 'text',
      'sender': ourUid,
      'receiver': theirUid,
      'content': msgContent,
    });
    print('--------------------------------\n');

    // 訊息格式為 PreKeySignalMessage
    if (isPreKeySignalMessage) {
      return {
        'isPreKeySignalMessage': isPreKeySignalMessage,
        'type': 'text',
        'sender': ourUid,
        'receiver': receiverUid,
        'receiverDeviceId': deviceId,
        'content': cihertext,
        'spkId': spkId,
        'opkId': opkId
      };
    }

    // 訊息格式為 SignalMessage
    else {
      return {
        'isPreKeySignalMessage': isPreKeySignalMessage,
        'type': 'text',
        'sender': ourUid,
        'receiver': receiverUid,
        'receiverDeviceId': deviceId,
        'content': cihertext
      };
    }
  }

  List allMsg = [];

  for (var deviceId in ourMsgInfo.keys) {
    var singleMsg =
        await returnMsgToServer(deviceId, ourMsgInfo[deviceId], ourUid);
    allMsg.add(singleMsg);
  }
  for (var deviceId in theirMsgInfo.keys) {
    var singleMsg =
        await returnMsgToServer(deviceId, theirMsgInfo[deviceId], theirUid);
    allMsg.add(singleMsg);
  }

  socket.emit('clientSendMsgToServer', jsonEncode(allMsg));
}
