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
import 'package:omelet/signal_protocol/v2_encrypt_pre_key_signal_message.dart';
import 'package:omelet/signal_protocol/v2_encrypt_signal_message.dart';
import 'package:omelet/storage/safe_device_id_store.dart';
import 'package:omelet/pages/login_signup/loading_page.dart' show socket;

Future<void> v2EncryptMsg(
    String theirUid, String plainText, String msgType) async {
  final ourUid = await loadCurrentActiveAccount();
  final safeDeviceIdStore = SafeDeviceIdStore();

  final ourDeviceIds = await safeDeviceIdStore.getTheirDeviceIds(ourUid);
  final theirDeviceIds = await safeDeviceIdStore.getTheirDeviceIds(theirUid);

  // 加密單一訊息
  Future<(bool, String)> encryptSingleMsg(
      String receiverUid, String receiverDeviceId) async {
    final receiverAddress =
        SignalProtocolAddress(receiverUid, int.parse(receiverDeviceId));

    // 建立 SessionStore
    final sessionStore = SafeSessionStore();

    // 判斷是否有 Session
    final sessionExsists = await sessionStore.containsSession(receiverAddress);

    // 讀取 SessionRecord
    final sessionRecord = await sessionStore.loadSession(receiverAddress);
    final sessionState = sessionRecord.sessionState;

    // 判斷是否有未確認的訊息
    final unackMsgExsists = sessionState.hasUnacknowledgedPreKeyMessage();

    print('🤎🤎🤎');
    print('接收者地址為：$receiverAddress');
    print('是否有 Session？$sessionExsists');
    print('是否有 未確認的訊息？$unackMsgExsists');
    print('是否有 session？$sessionExsists');
    print('是否有未確認的訊息？$unackMsgExsists');
    print('🤎🤎🤎\n');

    // 判斷加密的訊息類型
    if (!sessionExsists) {
      // 沒 Session，PreKeySignalMessage
      return await v2EncryptPreKeySignalMessage(
          receiverUid, receiverDeviceId, receiverAddress, plainText);
    } else {
      // 有 Session
      if (unackMsgExsists) {
        // 有 unackMsg，PreKeySignalMessage
        return await v2EncryptPreKeySignalMessage(
            receiverUid, receiverDeviceId, receiverAddress, plainText);
      } else {
        // 沒有 unackMsg，SignalMessage
        return await v2EncryptSignalMessage(receiverAddress, plainText);
      }
    }
  }

  for (var ourDeviceId in ourDeviceIds) {
    final (isPreKeySignalMessage, cipherText) =
        await encryptSingleMsg(ourUid, ourDeviceId);
    socket.emit(
        'clientSendMsgToServer',
        jsonEncode({
          'isPreKeySignalMessage': isPreKeySignalMessage,
          'type': msgType,
          'senderIpkPub': await loadIpkPub(),
          'sender': ourUid,
          'receiver': ourUid,
          'receiverDeviceId': ourDeviceId,
          'content': cipherText
        }));
  }

  for (var theirDeviceId in theirDeviceIds) {
    final (isPreKeySignalMessage, cipherText) =
        await encryptSingleMsg(theirUid, theirDeviceId);
    socket.emit(
        'clientSendMsgToServer',
        jsonEncode({
          'isPreKeySignalMessage': isPreKeySignalMessage,
          'type': msgType,
          'senderIpkPub': await loadIpkPub(),
          'sender': ourUid,
          'receiver': theirUid,
          'receiverDeviceId': theirDeviceId,
          'content': cipherText
        }));
  }

  print('😊😊😊😊😊');
  print(ourDeviceIds);
  print(theirDeviceIds);
  print('😊😊😊😊😊');
}
