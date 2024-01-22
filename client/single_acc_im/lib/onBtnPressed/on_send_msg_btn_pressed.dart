import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import './../signal_protocol/download_pre_key_bundle.dart';
import './../signal_protocol/encrypt_message.dart';
import '../main.dart' show socket;
import './../message/safe_msg_store.dart';

Future<void> onSendMsgBtnPressed(
    String remoteUid, String msgContent, Function updateHintMsg) async {
  final (ipkPub, spkPub, spkSig, opkPub, spkId, opkId) =
      await downloadPreKeyBundle(remoteUid);

  final cihertext = await encryptMessage(ipkPub, spkPub, spkSig, opkPub, spkId,
      opkId, remoteUid, msgContent, updateHintMsg);

  print('加密訊息：$cihertext');

  const storage = FlutterSecureStorage();
  final selfUid = await storage.read(key: 'uid');

  final currentTimestamp = DateTime.now().millisecondsSinceEpoch.toString();

  // sent msg
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

  // store msg sent
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
