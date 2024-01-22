import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import './../main.dart' show socket;
import './../message/safe_msg_store.dart';
import './../signal_protocol/encrypt_message.dart';
import './../signal_protocol/download_pre_key_bundle.dart';

Future<void> onSendMsgBtnPressed(
    String remoteUid, String msgContent, Function updateHintMsg) async {
  const storage = FlutterSecureStorage();
  final selfUid = await storage.read(key: 'uid');
  final currentTimestamp = DateTime.now().millisecondsSinceEpoch.toString();

  // 準備對方的 Pre Key Bundle
  final (ipkPub, spkPub, spkSig, opkPub, spkId, opkId) =
      await downloadPreKeyBundle(remoteUid);

  // 加密訊息
  final cihertext = await encryptMessage(ipkPub, spkPub, spkSig, opkPub, spkId,
      opkId, remoteUid, msgContent, updateHintMsg);

  // 發送訊息
  socket.emit('clientSendMsgToServer', {
    'timestamp': currentTimestamp,
    'type': 'text',
    'sender': selfUid,
    'receiver': remoteUid,
    'content': cihertext,
    'isPreKeySignaleMessage': true,
    'spkId': spkId,
    'opkId': opkId
  });

  // 儲存發送的訊息
  final safeMsgStore = SafeMsgStore();
  safeMsgStore.writeMsg(remoteUid, {
    'timestamp': currentTimestamp,
    'type': 'text',
    'sender': selfUid,
    'receiver': remoteUid,
    'content': msgContent,
    'isPreKeySignaleMessage': true
  });
}
