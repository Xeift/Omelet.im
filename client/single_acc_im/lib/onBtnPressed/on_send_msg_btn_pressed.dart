import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './../signal_protocol/download_pre_key_bundle.dart';
import './../signal_protocol/encrypt_message.dart';
import '../main.dart' show socket;

Future<void> onSendMsgBtnPressed(
    String receiverId, String msgContent, Function updateHintMsg) async {
  final (ipkPub, spkPub, spkSig, opkPub, opkId, spkId) =
      await downloadPreKeyBundle(receiverId);

  final cihertext = await encryptMessage(ipkPub, spkPub, spkSig, opkPub, opkId,
      spkId, receiverId, msgContent, updateHintMsg);

  print('加密訊息：$cihertext');

  const storage = FlutterSecureStorage();
  final selfUid = await storage.read(key: 'uid');

  // sent msg
  socket.emit('clientSendMsgToServer', {
    'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
    'sender': selfUid,
    'receiver': receiverId,
    'type': 'text',
    'content': cihertext
  });
}
