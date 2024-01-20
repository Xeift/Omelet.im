import './../signal_protocol/download_pre_key_bundle.dart';
import './../signal_protocol/encrypt_message.dart';

Future<void> onSendMsgBtnPressed(
    String receiverId, String msgContent, Function updateHintMsg) async {
  final (ipkPub, spkPub, spkSig, opkPub, opkId, spkId) =
      await downloadPreKeyBundle(receiverId);

  final cihertext = await encryptMessage(ipkPub, spkPub, spkSig, opkPub, opkId,
      spkId, receiverId, msgContent, updateHintMsg);

  print('加密訊息：$cihertext');
}
