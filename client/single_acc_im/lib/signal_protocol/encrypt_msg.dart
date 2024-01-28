// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import './../signal_protocol/safe_spk_store.dart';
import './../signal_protocol/safe_opk_store.dart';
import './../signal_protocol/safe_session_store.dart';
import './../signal_protocol/safe_identity_store.dart';
import './../signal_protocol/download_pre_key_bundle.dart';

Future<(String, bool, int?, int?)> encryptMsg(
    String remoteUid, String msgContent, Function updateHintMsg) async {
  final ipkStore = SafeIdentityKeyStore();
  final registrationId = await ipkStore.getLocalRegistrationId();
  final spkStore = SafeSpkStore();
  final opkStore = SafeOpkStore();
  final remoteAddress = SignalProtocolAddress(remoteUid.toString(), 1);

  // 建立 SessionStore
  final sessionStore = SafeSessionStore();
  final sessionNotExsist = !(await sessionStore.containsSession(remoteAddress));

  // 讀取 SessionRecord
  final sessionRecord = await sessionStore.loadSession(remoteAddress);
  final sessionState = sessionRecord.sessionState;

  Future<(String, bool, int?, int?)> encryptPreKeySignalMessage() async {
    // 準備對方的 Pre Key Bundle
    final (ipkPub, spkPub, spkSig, opkPub, spkId, opkId) =
        await downloadPreKeyBundle(remoteUid);
    final sessionBuilder = SessionBuilder(
        sessionStore, opkStore, spkStore, ipkStore, remoteAddress);

    // 用 SessionBuilder 處理 PreKeyBundle
    final retrievedPreKeyBundle = PreKeyBundle(
        registrationId, 1, opkId, opkPub, spkId, spkPub, spkSig, ipkPub);
    await sessionBuilder.processPreKeyBundle(retrievedPreKeyBundle);

    // 建立 SessionCipher，用於加密訊息
    final sessionCipher = SessionCipher(
        sessionStore, opkStore, spkStore, ipkStore, remoteAddress);

    // ciphertext 形態為 PreKeySignalMessage(prekeyType)
    final ciphertext = await sessionCipher
        .encrypt(Uint8List.fromList(utf8.encode(msgContent)));
    final isPreKeySignalMessage =
        ciphertext.getType() == CiphertextMessage.prekeyType;

    print('[encrypt_msg.dart] ciphertext type: ${ciphertext.getType()}');
    print('end of encrypt_msg.dart--------------------------------');

    return (
      jsonEncode(ciphertext.serialize()),
      isPreKeySignalMessage,
      spkId,
      opkId
    );
  }

  Future<(String, bool, int?, int?)> encryptSignalMessage() async {
    // 建立 SessionCipher，用於加密訊息
    final sessionCipher = SessionCipher(
        sessionStore, opkStore, spkStore, ipkStore, remoteAddress);

    // ciphertext 形態可能為 PreKeySignalMessage(prekeyType) 或 SignalMessage(whisperType)
    final ciphertext = await sessionCipher
        .encrypt(Uint8List.fromList(utf8.encode(msgContent)));
    final isPreKeySignalMessage =
        ciphertext.getType() == CiphertextMessage.prekeyType;

    print('[encrypt_msg.dart] ciphertext type: ${ciphertext.getType()}');

    print('end of encrypt_msg.dart--------------------------------');

    return (
      jsonEncode(ciphertext.serialize()),
      isPreKeySignalMessage,
      null,
      null
    );
  }

  // 沒有 Session，Message 形態為 PreKeySignal，需要 SessionBuilder
  if (sessionNotExsist) {
    print('[encrypt_msg.dart] no session!');
    return await encryptPreKeySignalMessage();
  }
  // 有 Session
  else {
    print('[encrypt_msg.dart] have session!');

    // 對方未確認，Message 形態為 PreKeySignalMessage
    if (sessionState.hasUnacknowledgedPreKeyMessage()) {
      print('[encrypt_msg.dart] have unack!');
      return await encryptPreKeySignalMessage();
    }
    // 對方已確認，Message 形態為 SignalMessage
    else {
      print('[encrypt_msg.dart] no unack!');
      return await encryptSignalMessage();
    }
  }
}
