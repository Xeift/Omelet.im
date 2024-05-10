import 'dart:convert';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import 'package:omelet/signal_protocol/safe_signal_protocol_store.dart';

Future<String> decryptMsg(bool isPreKeySignalMessage, String remoteUid,
    int remoteDeviceId, String ciphertext) async {
  final signalProtocolStore = SafeSignalProtocolStore();
  final remoteAddress = SignalProtocolAddress(
      remoteUid.toString(), remoteDeviceId); // Signal protocol 地址

  // 建立 SessionCipher，用於解密訊息
  final selfSessionCipher =
      SessionCipher.fromStore(signalProtocolStore, remoteAddress);
  final String plainText;

  // 解密訊息
  if (isPreKeySignalMessage) {
    plainText = utf8.decode(await selfSessionCipher.decrypt(PreKeySignalMessage(
        Uint8List.fromList(jsonDecode(ciphertext).cast<int>().toList()))));
  } else {
    final listFormatCipherText =
        Uint8List.fromList(jsonDecode(ciphertext).cast<int>().toList());

    final listFormatCipherTextSignalMsg =
        SignalMessage.fromSerialized(listFormatCipherText);

    plainText = utf8.decode(await selfSessionCipher
        .decryptFromSignal(listFormatCipherTextSignalMsg));
  }

  return plainText;
}
