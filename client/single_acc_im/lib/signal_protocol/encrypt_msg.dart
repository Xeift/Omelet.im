// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import './../signal_protocol/safe_spk_store.dart';
import './../signal_protocol/safe_opk_store.dart';
import './../signal_protocol/safe_session_store.dart';
import './../signal_protocol/safe_identity_store.dart';
import './../signal_protocol/download_pre_key_bundle.dart';

Future<(String, int?, int?)> encryptMsg(String remoteUid, String msgContent,
    bool isPreKeySignalMessage, Function updateHintMsg) async {
  final ipkStore = SafeIdentityKeyStore();
  final registrationId = await ipkStore.getLocalRegistrationId();
  final spkStore = SafeSpkStore();
  final opkStore = SafeOpkStore();
  final remoteAddress = SignalProtocolAddress(remoteUid.toString(), 1);

  // 建立 SessionStore
  final sessionStore = SafeSessionStore();

  // 第一次傳送訊息需要 sessionBuilder
  if (isPreKeySignalMessage) {
    print('no session!');
    // 準備對方的 Pre Key Bundle （只有第一次）
    final (ipkPub, spkPub, spkSig, opkPub, spkId, opkId) =
        await downloadPreKeyBundle(remoteUid);
    final sessionBuilder = SessionBuilder(
        sessionStore, opkStore, spkStore, ipkStore, remoteAddress);

    // 用 sessionBuilder 處理 PreKeyBundle
    final retrievedPreKeyBundle = PreKeyBundle(
        registrationId, 1, opkId, opkPub, spkId, spkPub, spkSig, ipkPub);
    await sessionBuilder.processPreKeyBundle(retrievedPreKeyBundle);

    // 建立 SessionCipher，用於加密訊息
    final sessionCipher = SessionCipher(
        sessionStore, opkStore, spkStore, ipkStore, remoteAddress);
    final ciphertext = await sessionCipher
        .encrypt(Uint8List.fromList(utf8.encode(msgContent)));

    return (jsonEncode(ciphertext.serialize()), spkId, opkId);
  } else {
    print('have session!');
    // 建立 SessionCipher，用於加密訊息
    final sessionCipher = SessionCipher(
        sessionStore, opkStore, spkStore, ipkStore, remoteAddress);
    final ciphertext = await sessionCipher
        .encrypt(Uint8List.fromList(utf8.encode(msgContent)));

    return (jsonEncode(ciphertext.serialize()), null, null);
  }
}
