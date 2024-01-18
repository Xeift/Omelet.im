import './../signal_protocol/download_pre_key_bundle.dart';

Future<void> onSendMsgBtnPressed(
    String receiverId, String msgContent, Function updateHintMsg) async {
  final (ipkPub, spkPub, spkSig, opkPub) =
      await downloadPreKeyBundle(receiverId);

  print(ipkPub);
  print(spkPub);
  print(spkSig);
  print(opkPub);
}
