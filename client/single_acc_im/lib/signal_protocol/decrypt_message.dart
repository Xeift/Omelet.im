import 'dart:convert';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import 'safe_identity_store.dart';
import 'safe_spk_store.dart';
import 'safe_opk_store.dart';
import 'safe_session_store.dart';
import 'safe_signal_protocol_store.dart';

Future<String> decryptMsg(
    int remoteUid, String ciphertext, int spkId, int opkId) async {
  print('spk🎁  $spkId');

  // 模擬建立 Bob 的 SessionCipher，用於解密訊息
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
