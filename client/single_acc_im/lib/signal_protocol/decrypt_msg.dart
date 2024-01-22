import 'dart:convert';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import 'safe_signal_protocol_store.dart';

Future<String> decryptMsg(
    int remoteUid, String ciphertext, int spkId, int opkId) async {
  // 建立 SessionCipher，用於解密訊息
  final signalProtocolStore = SafeSignalProtocolStore();
  final remoteAddress =
      SignalProtocolAddress(remoteUid.toString(), 1); // Signal protocol 地址
  final selfSessionCipher =
      SessionCipher.fromStore(signalProtocolStore, remoteAddress);

  // 解密訊息
  // if (ciphertext.getType() == CiphertextMessage.prekeyType) {
  await selfSessionCipher.decryptWithCallback(
      PreKeySignalMessage(
          Uint8List.fromList(jsonDecode(ciphertext).cast<int>().toList())),
      (plaintext) {
    print(utf8.decode(plaintext));
  });
  // }
  return 'a';
}
