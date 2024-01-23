import 'dart:convert';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import 'safe_signal_protocol_store.dart';

Future<String> decryptMsg(int remoteUid, String ciphertext) async {
  // 建立 SessionCipher，用於解密訊息
  final signalProtocolStore = SafeSignalProtocolStore();
  final remoteAddress =
      SignalProtocolAddress(remoteUid.toString(), 1); // Signal protocol 地址
  final selfSessionCipher =
      SessionCipher.fromStore(signalProtocolStore, remoteAddress);

  // 解密訊息
  // if (ciphertext.getType() == CiphertextMessage.prekeyType) {
  // }

  final plainText = utf8.decode(await selfSessionCipher.decrypt(
      PreKeySignalMessage(
          Uint8List.fromList(jsonDecode(ciphertext).cast<int>().toList()))));

  return plainText;
}
