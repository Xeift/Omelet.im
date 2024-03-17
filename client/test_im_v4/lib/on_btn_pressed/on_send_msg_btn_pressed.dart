// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:test_im_v4/message/safe_msg_store.dart';
import 'package:test_im_v4/api/post/upload_img_api.dart';
import 'package:test_im_v4/signal_protocol/encrypt_msg.dart';
import 'package:test_im_v4/utils/init_socket.dart' show socket;
import 'package:test_im_v4/on_btn_pressed/on_select_image_btn_pressed.dart'
    show imagePath, resetImagePath;

Future<void> onSendMsgBtnPressed(
    String theirUid, String msgContent, Function updateHintMsg) async {
  print('--------------------------------');
  String msgType;
  print('[on_send_msg_btn_pressed.dart] msgContent: $msgContent');

  const storage = FlutterSecureStorage();
  final ourUid = (await storage.read(key: 'uid')).toString();
  final currentTimestamp = DateTime.now().millisecondsSinceEpoch.toString();

  if (imagePath != null) {
    var img = File(imagePath.toString());
    var imgBytes = jsonEncode(await img.readAsBytes());
    msgType = 'image';

    // var encryptedBytes = Uint8List.fromList(imgBytes);
    final encryptedImg = await encryptMsg(theirUid, imgBytes);
    final ourEncryptedImg = encryptedImg['ourEncryptedMsg'];
    final theirEncryptedImg = encryptedImg['theirEncryptedMsg'];

    for (var deviceId in ourEncryptedImg.keys) {
      var res = await uploadImgApi(imgBytes, ourUid, deviceId);
      print(
          '[on_send_msg_btn_pressed.dart] ${await res.stream.bytesToString()}');
    }
    for (var deviceId in theirEncryptedImg.keys) {
      var res = await uploadImgApi(imgBytes, theirUid, deviceId);
      print(
          '[on_send_msg_btn_pressed.dart] ${await res.stream.bytesToString()}');
    }

    resetImagePath();
  } else {
    msgType = 'text';
  }

  // 加密訊息
  final encryptedMsg = await encryptMsg(theirUid, msgContent);
  final ourEncryptedMsg = encryptedMsg['ourEncryptedMsg'];
  final theirEncryptedMsg = encryptedMsg['theirEncryptedMsg'];

  print('🎈🎈🎈🎈🎈🎈🎈🎈🎈🎈🎈🎈');
  print('[on_send_msg_btn_pressed.dart] msgContent: $msgContent');
  print('[on_send_msg_btn_pressed.dart] imagePath: $imagePath');
  print('[on_send_msg_btn_pressed.dart] msgInfo👉: $encryptedMsg');
  print('[on_send_msg_btn_pressed.dart] ourMsgInfo👉: $ourEncryptedMsg');
  print('[on_send_msg_btn_pressed.dart] theirMsgInfo👉: $theirEncryptedMsg');
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

  for (var deviceId in ourEncryptedMsg.keys) {
    var singleMsg =
        await returnMsgToServer(deviceId, ourEncryptedMsg[deviceId], ourUid);
    socket.emit('clientSendMsgToServer', jsonEncode(singleMsg));
  }
  for (var deviceId in theirEncryptedMsg.keys) {
    var singleMsg = await returnMsgToServer(
        deviceId, theirEncryptedMsg[deviceId], theirUid);
    socket.emit('clientSendMsgToServer', jsonEncode(singleMsg));
  }
}
