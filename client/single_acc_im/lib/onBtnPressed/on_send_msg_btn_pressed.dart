import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import './../main.dart' show socket;
import './../message/safe_msg_store.dart';
import '../signal_protocol/encrypt_msg.dart';

Future<void> onSendMsgBtnPressed(
    String remoteUid, String msgContent, Function updateHintMsg) async {
  const storage = FlutterSecureStorage();
  final selfUid = await storage.read(key: 'uid');
  final currentTimestamp = DateTime.now().millisecondsSinceEpoch.toString();

  // 加密訊息
  final (cihertext, spkId, opkId) =
      await encryptMsg(remoteUid, msgContent, updateHintMsg);

  // 第二次發送訊息
  if (spkId == null) {
    print('two');
    socket.emit('clientSendMsgToServer', {
      'isPreKeySignalMessage': false,
      'type': 'text',
      'sender': selfUid,
      'receiver': remoteUid,
      'content': cihertext
    });
  }

  // 第一次發送訊息
  else {
    print('one');
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
