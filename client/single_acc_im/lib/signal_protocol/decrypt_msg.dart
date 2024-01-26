// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import 'safe_session_store.dart';
import 'safe_signal_protocol_store.dart';

Future<String> decryptMsg(int remoteUid, String ciphertext) async {
  final signalProtocolStore = SafeSignalProtocolStore();
  final remoteAddress =
      SignalProtocolAddress(remoteUid.toString(), 1); // Signal protocol 地址

  // 建立 SessionCipher，用於解密訊息
  final selfSessionCipher =
      SessionCipher.fromStore(signalProtocolStore, remoteAddress);
  final String plainText;
  final sessionStore = SafeSessionStore();
  final isPreKeySignalMessage =
      !(await sessionStore.containsSession(remoteAddress));

  // 解密訊息
  if (isPreKeySignalMessage) {
    print('[receive 1st]');
    plainText = utf8.decode(await selfSessionCipher.decrypt(PreKeySignalMessage(
        Uint8List.fromList(jsonDecode(ciphertext).cast<int>().toList()))));
  } else {
    print('[receive 2nd]');

    final listFormatCipherText =
        Uint8List.fromList(jsonDecode(ciphertext).cast<int>().toList());
    print(listFormatCipherText);
    print('😎');

    final listFormatCipherTextSignalMsg =
        SignalMessage.fromSerialized(listFormatCipherText);
    print(listFormatCipherTextSignalMsg);
    print('😂1');

    plainText = utf8.decode(await selfSessionCipher
        .decryptFromSignal(listFormatCipherTextSignalMsg));
  }
  print(plainText);
  return plainText;
}
