import 'dart:convert';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import 'package:omelet/signal_protocol/safe_spk_store.dart';
import 'package:omelet/signal_protocol/safe_opk_store.dart';
import 'package:omelet/signal_protocol/safe_session_store.dart';
import 'package:omelet/signal_protocol/safe_identity_store.dart';

Future<(String, bool, dynamic, dynamic)> v2EncryptSignalMessage(
    SignalProtocolAddress receiverAddress, String plainText) async {
  final ipkStore = SafeIdentityKeyStore();
  final spkStore = SafeSpkStore();
  final opkStore = SafeOpkStore();
  final sessionStore = SafeSessionStore();

  // 建立 SessionCipher，用於加密訊息
  final sessionCipher = SessionCipher(
      sessionStore, opkStore, spkStore, ipkStore, receiverAddress);

  // ciphertext 形態可能為 PreKeySignalMessage(prekeyType) 或 SignalMessage(whisperType)
  final ciphertext =
      await sessionCipher.encrypt(Uint8List.fromList(utf8.encode(plainText)));
  final isPreKeySignalMessage =
      ciphertext.getType() == CiphertextMessage.prekeyType;

  return (
    jsonEncode(ciphertext.serialize()),
    isPreKeySignalMessage,
    null,
    null
  );
}
