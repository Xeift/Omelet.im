import 'dart:convert';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import 'package:omelet/storage/safe_account_store.dart';
import 'package:omelet/signal_protocol/safe_session_store.dart';
import 'package:omelet/signal_protocol/encrypt_pre_key_signal_message.dart';
import 'package:omelet/signal_protocol/encrypt_signal_message.dart';
import 'package:omelet/storage/safe_device_id_store.dart';
import 'package:omelet/pages/login_signup/loading_page.dart' show socket;
import 'package:omelet/utils/generate_random_filename.dart';
import 'package:omelet/api/post/upload_img_api.dart';

Future<void> encryptMsg(
    String theirUid, String plainText, String msgType) async {
  final ourUid = await loadCurrentActiveAccount();
  final safeDeviceIdStore = SafeDeviceIdStore();
  final senderDeviceId = await safeDeviceIdStore.getLocalDeviceId();

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

    // 判斷加密的訊息類型
    if (!sessionExsists) {
      // 沒 Session，PreKeySignalMessage
      return await encryptPreKeySignalMessage(
          receiverUid, receiverDeviceId, receiverAddress, plainText);
    } else {
      // 有 Session
      if (unackMsgExsists) {
        // 有 unackMsg，PreKeySignalMessage
        return await encryptPreKeySignalMessage(
            receiverUid, receiverDeviceId, receiverAddress, plainText);
      } else {
        // 沒有 unackMsg，SignalMessage
        return await encryptSignalMessage(receiverAddress, plainText);
      }
    }
  }

  if (msgType == 'text') {
    for (var ourDeviceId in ourDeviceIds) {
      final (isPreKeySignalMessage, cipherText) =
          await encryptSingleMsg(ourUid, ourDeviceId);
      socket.emit(
          'clientSendMsgToServer',
          jsonEncode({
            'isPreKeySignalMessage': isPreKeySignalMessage,
            'type': msgType,
            'senderDeviceId': senderDeviceId,
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
            'senderDeviceId': senderDeviceId,
            'sender': ourUid,
            'receiver': theirUid,
            'receiverDeviceId': theirDeviceId,
            'content': cipherText
          }));
    }
  } else if (msgType == 'image') {
    for (var ourDeviceId in ourDeviceIds) {
      final (isPreKeySignalMessage, cipherText) =
          await encryptSingleMsg(ourUid, ourDeviceId);

      var filename = generateRandomFileName(); // 產生隨機檔名
      await uploadImgApi(isPreKeySignalMessage, ourUid, ourUid, ourDeviceId,
          cipherText, filename);
    }

    for (var theirDeviceId in theirDeviceIds) {
      final (isPreKeySignalMessage, cipherText) =
          await encryptSingleMsg(theirUid, theirDeviceId);

      var filename = generateRandomFileName(); // 產生隨機檔名
      await uploadImgApi(isPreKeySignalMessage, theirUid, theirUid,
          theirDeviceId, cipherText, filename);
    }
  }
}
