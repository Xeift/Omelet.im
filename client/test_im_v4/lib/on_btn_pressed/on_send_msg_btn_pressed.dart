// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:test_im_v4/message/safe_msg_store.dart';
import 'package:test_im_v4/signal_protocol/encrypt_msg.dart';
import 'package:test_im_v4/utils/init_socket.dart' show socket;
import 'package:test_im_v4/on_btn_pressed/on_select_image_btn_pressed.dart'
    show imagePath, resetImagePath;

Future<void> onSendMsgBtnPressed(
    String theirUid, String msgContent, Function updateHintMsg) async {
  print('--------------------------------');
  String msgType;

  if (imagePath != null) {
    var img = File(imagePath.toString());
    msgContent = jsonEncode(await img.readAsBytes());
    msgType = 'image';
    resetImagePath();
  } else {
    msgType = 'text';
  }

  print('[on_send_msg_btn_pressed.dart] msgContent: $msgContent');

  const storage = FlutterSecureStorage();
  final ourUid = (await storage.read(key: 'uid')).toString();
  final currentTimestamp = DateTime.now().millisecondsSinceEpoch.toString();

  // 加密訊息
  final msgInfo = await encryptMsg(theirUid, msgContent, updateHintMsg);
  final ourMsgInfo = msgInfo['ourMsgInfo'];
  final theirMsgInfo = msgInfo['theirMsgInfo'];

  print('🎈🎈🎈🎈🎈🎈🎈🎈🎈🎈🎈🎈');
  print('[on_send_msg_btn_pressed.dart] msgContent: $msgContent');
  print('[on_send_msg_btn_pressed.dart] imagePath: $imagePath');
  print('[on_send_msg_btn_pressed.dart] msgInfo👉: $msgInfo');
  print('[on_send_msg_btn_pressed.dart] ourMsgInfo👉: $ourMsgInfo');
  print('[on_send_msg_btn_pressed.dart] theirMsgInfo👉: $theirMsgInfo');
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
    await safeMsgStore.writeMsg(theirUid, {
      'timestamp': currentTimestamp,
      'type': msgType,
      'sender': ourUid,
      'receiver': theirUid,
      'content': msgContent,
    });
    print('--------------------------------\n');

    // 訊息格式為 PreKeySignalMessage
    if (isPreKeySignalMessage) {
      return {
        'isPreKeySignalMessage': isPreKeySignalMessage,
        'type': msgType,
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
        'type': msgType,
        'sender': ourUid,
        'receiver': receiverUid,
        'receiverDeviceId': deviceId,
        'content': cihertext
      };
    }
  }

  for (var deviceId in ourMsgInfo.keys) {
    var singleMsg =
        await returnMsgToServer(deviceId, ourMsgInfo[deviceId], ourUid);
    socket.emit('clientSendMsgToServer', jsonEncode(singleMsg));
  }
  for (var deviceId in theirMsgInfo.keys) {
    var singleMsg =
        await returnMsgToServer(deviceId, theirMsgInfo[deviceId], theirUid);
    socket.emit('clientSendMsgToServer', jsonEncode(singleMsg));
  }
}
