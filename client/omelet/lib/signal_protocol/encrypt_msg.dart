// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import 'package:omelet/utils/load_local_info.dart';
import 'package:omelet/signal_protocol/safe_spk_store.dart';
import 'package:omelet/signal_protocol/safe_opk_store.dart';
import 'package:omelet/signal_protocol/safe_session_store.dart';
import 'package:omelet/signal_protocol/safe_identity_store.dart';
import 'package:omelet/signal_protocol/download_pre_key_bundle.dart';

Future<Map<String, dynamic>> encryptMsg(
    String remoteUid, String msgContent) async {
  final ourUid = await loadCurrentActiveAccount();
  final ipkStore = SafeIdentityKeyStore();
  final registrationId = await ipkStore.getLocalRegistrationId();
  final spkStore = SafeSpkStore();
  final opkStore = SafeOpkStore();

  Future<(String, bool, dynamic, dynamic)> encryptSingleMsg(
      String deviceId, dynamic singlePreKeyBundle, String receiverUid) async {
    final (ipkPub, spkPub, spkSig, opkPub, spkId, opkId) =
        await singlePreKeyBundle;

    print('--------------------------------');
    print(ipkPub);
    print(spkPub);
    print(spkSig);
    print(opkPub);
    print(spkId);
    print(opkId);
    print('--------------------------------\n');

    final remoteAddress =
        SignalProtocolAddress(receiverUid, int.parse(deviceId));

    // 建立 SessionStore
    final sessionStore = SafeSessionStore();
    final sessionNotExsist =
        !(await sessionStore.containsSession(remoteAddress));

    // 讀取 SessionRecord
    final sessionRecord = await sessionStore.loadSession(remoteAddress);
    final sessionState = sessionRecord.sessionState;

    Future<(String, bool, dynamic, dynamic)>
        encryptPreKeySignalMessage() async {
      final sessionBuilder = SessionBuilder(
          sessionStore, opkStore, spkStore, ipkStore, remoteAddress);

      // 用 SessionBuilder 處理 PreKeyBundle
      final retrievedPreKeyBundle = PreKeyBundle(registrationId,
          int.parse(deviceId), opkId, opkPub, spkId, spkPub, spkSig, ipkPub);
      await sessionBuilder.processPreKeyBundle(retrievedPreKeyBundle);

      // 建立 SessionCipher，用於加密訊息
      final sessionCipher = SessionCipher(
          sessionStore, opkStore, spkStore, ipkStore, remoteAddress);

      // ciphertext 形態為 PreKeySignalMessage(prekeyType)
      final ciphertext = await sessionCipher
          .encrypt(Uint8List.fromList(utf8.encode(msgContent)));
      final isPreKeySignalMessage =
          ciphertext.getType() == CiphertextMessage.prekeyType;

      return (
        jsonEncode(ciphertext.serialize()),
        isPreKeySignalMessage,
        spkId,
        opkId
      );
    }

    Future<(String, bool, dynamic, dynamic)> encryptSignalMessage() async {
      // 建立 SessionCipher，用於加密訊息
      final sessionCipher = SessionCipher(
          sessionStore, opkStore, spkStore, ipkStore, remoteAddress);

      // ciphertext 形態可能為 PreKeySignalMessage(prekeyType) 或 SignalMessage(whisperType)
      final ciphertext = await sessionCipher
          .encrypt(Uint8List.fromList(utf8.encode(msgContent)));
      final isPreKeySignalMessage =
          ciphertext.getType() == CiphertextMessage.prekeyType;

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

  // 準備所有裝置的 Pre Key Bundle（包含自己及對方）
  final Map<String, dynamic> multiDevicesPreKeyBundle =
      await downloadPreKeyBundle(remoteUid);
  print('[encrypt_msg] multiDevicesPreKeyBundle: $multiDevicesPreKeyBundle');
  // 自己其他裝置的 Pre Key Bundle
  final ourPreKeyBundleConverted =
      await multiDevicesPreKeyBundle['ourPreKeyBundleConverted'];
  final Map<String, dynamic> ourMsgInfo = {};
  for (var key in ourPreKeyBundleConverted.keys) {
    var value = ourPreKeyBundleConverted[key];
    ourMsgInfo[key] = await encryptSingleMsg(key, value, ourUid);
  }

  // 對方所有裝置的 Pre Key Bundle
  final theirPreKeyBundleConverted =
      await multiDevicesPreKeyBundle['theirPreKeyBundleConverted'];
  final Map<String, dynamic> theirMsgInfo = {};
  for (var key in theirPreKeyBundleConverted.keys) {
    var value = theirPreKeyBundleConverted[key];
    theirMsgInfo[key] = await encryptSingleMsg(key, value, remoteUid);
    print('😎 ${theirMsgInfo[key]}');
  }

  return {'ourMsgInfo': ourMsgInfo, 'theirMsgInfo': theirMsgInfo};
}
