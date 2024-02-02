// ignore_for_file: avoid_print

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import './../main.dart' show socket;
import './../message/safe_msg_store.dart';
import './../signal_protocol/encrypt_msg.dart';

Future<void> onSendMsgBtnPressed(
    String remoteUid, String msgContent, Function updateHintMsg) async {
  print('--------------------------------');
  const storage = FlutterSecureStorage();
  final selfUid = await storage.read(key: 'uid');
  final currentTimestamp = DateTime.now().millisecondsSinceEpoch.toString();

  // 加密訊息
  final (cihertext, isPreKeySignalMessage, spkId, opkId) =
      await encryptMsg(remoteUid, msgContent, updateHintMsg);

  // 訊息格式為 PreKeySignalMessage
  if (isPreKeySignalMessage) {
    socket.emit('clientSendMsgToServer', {
      'isPreKeySignalMessage': isPreKeySignalMessage,
      'type': 'text',
      'sender': selfUid,
      'receiver': remoteUid,
      'content': cihertext,
      'spkId': spkId,
      'opkId': opkId
    });
  }

  // 訊息格式為 SignalMessage
  else {
    socket.emit('clientSendMsgToServer', {
      'isPreKeySignalMessage': isPreKeySignalMessage,
      'type': 'text',
      'sender': selfUid,
      'receiver': remoteUid,
      'content': cihertext
    });
  }

  // 將發送的訊息儲存到本地
  final safeMsgStore = SafeMsgStore();
  safeMsgStore.writeMsg(remoteUid, {
    'timestamp': currentTimestamp,
    'type': 'text',
    'sender': selfUid,
    'receiver': remoteUid,
    'content': msgContent,
  });
  print('--------------------------------\n');
}
