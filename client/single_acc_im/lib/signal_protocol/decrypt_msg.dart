import 'dart:convert';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import 'safe_signal_protocol_store.dart';

Future<String> decryptMsg(
    int remoteUid, String ciphertext, bool isPreKeySignalMessage) async {
  // 建立 SessionCipher，用於解密訊息
  final signalProtocolStore = SafeSignalProtocolStore();
  final remoteAddress =
      SignalProtocolAddress(remoteUid.toString(), 1); // Signal protocol 地址
  final selfSessionCipher =
      SessionCipher.fromStore(signalProtocolStore, remoteAddress);
  final String plainText;
  // 解密訊息
  if (isPreKeySignalMessage) {
    print('use pre-key-signal!!!');
    plainText = utf8.decode(await selfSessionCipher.decrypt(PreKeySignalMessage(
        Uint8List.fromList(jsonDecode(ciphertext).cast<int>().toList()))));
  } else {
    print('use normal!!!');
    plainText = utf8.decode(await selfSessionCipher.decryptFromSignal(
        SignalMessage.fromSerialized(
            Uint8List.fromList(jsonDecode(ciphertext).cast<int>().toList()))));
  }

  return plainText;
}
