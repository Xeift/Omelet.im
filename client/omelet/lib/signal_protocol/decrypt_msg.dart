// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import 'package:omelet/signal_protocol/safe_signal_protocol_store.dart';

Future<String> decryptMsg(
    bool isPreKeySignalMessage, int remoteUid, String ciphertext) async {
  final signalProtocolStore = SafeSignalProtocolStore();
  final remoteAddress =
      SignalProtocolAddress(remoteUid.toString(), 1); // Signal protocol 地址

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
  print('[decrypt_msg.dart] 已解密訊息👉 $plainText');
  return plainText;
}
