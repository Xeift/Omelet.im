// ignore_for_file: avoid_print

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import './../main.dart' show socket;
import './../message/safe_msg_store.dart';
import './../signal_protocol/encrypt_msg.dart';
import './../signal_protocol/safe_session_store.dart';

Future<void> onSendMsgBtnPressed(
    String remoteUid, String msgContent, Function updateHintMsg) async {
  const storage = FlutterSecureStorage();
  final sessionStore = SafeSessionStore();
  final remoteAddress = SignalProtocolAddress(remoteUid, 1);
  final isPreKeySignalMessage =
      !(await sessionStore.containsSession(remoteAddress));

  final selfUid = await storage.read(key: 'uid');
  final currentTimestamp = DateTime.now().millisecondsSinceEpoch.toString();

  // 加密訊息
  final (cihertext, spkId, opkId) = await encryptMsg(
      remoteUid, msgContent, isPreKeySignalMessage, updateHintMsg);

  // 第一次發送訊息
  if (isPreKeySignalMessage) {
    print('[send 1st]');
    socket.emit('clientSendMsgToServer', {
      'isPreKeySignalMessage': true,
      'type': 'text',
      'sender': selfUid,
      'receiver': remoteUid,
      'content': cihertext,
      'spkId': spkId,
      'opkId': opkId
    });
  }
  // 第二次發送訊息
  else {
    print('[send 2nd]');
    socket.emit('clientSendMsgToServer', {
      'isPreKeySignalMessage': false,
      'type': 'text',
      'sender': selfUid,
      'receiver': remoteUid,
      'content': cihertext
    });
  }

  // 儲存發送的訊息
  final safeMsgStore = SafeMsgStore();
  safeMsgStore.writeMsg(remoteUid, {
    'timestamp': currentTimestamp,
    'type': 'text',
    'sender': selfUid,
    'receiver': remoteUid,
    'content': msgContent,
  });
}
