import 'dart:convert';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import 'package:omelet/api/get/download_pre_key_bundle_api.dart';
import 'package:omelet/signal_protocol/safe_spk_store.dart';
import 'package:omelet/signal_protocol/safe_opk_store.dart';
import 'package:omelet/signal_protocol/safe_session_store.dart';
import 'package:omelet/signal_protocol/safe_identity_store.dart';
import 'package:omelet/signal_protocol/pre_key_bundle_converter.dart';

Future<(bool, String)> encryptPreKeySignalMessage(
    String theirUid,
    String theirDeviceId,
    SignalProtocolAddress receiverAddress,
    String plainText) async {
  final ipkStore = SafeIdentityKeyStore();
  final spkStore = SafeSpkStore();
  final opkStore = SafeOpkStore();
  final sessionStore = SafeSessionStore();
  final registrationId = await ipkStore.getLocalRegistrationId();

  // 下載單一 PreKeyBundle
  final res = await downloadPreKeyBundleApi(theirUid, theirDeviceId);
  final preKeyBundle = jsonDecode(res.body)['data']['PreKeyBundle'];
  print('❌❌❌❌❌');
  // 轉換成函式庫能使用的形態
  final (ipkPub, spkPub, spkSig, opkPub, spkId, opkId) =
      await preKeyBundleTypeConverter(theirDeviceId, preKeyBundle);

  print(ipkPub.publicKey.serialize());
  print(spkSig);
  print(spkId);
  print('❌❌❌❌❌');

  final sessionBuilder = SessionBuilder(
      sessionStore, opkStore, spkStore, ipkStore, receiverAddress);

  // 用 SessionBuilder 處理 PreKeyBundle
  final retrievedPreKeyBundle = PreKeyBundle(registrationId,
      int.parse(theirDeviceId), opkId, opkPub, spkId, spkPub, spkSig, ipkPub);
  await sessionBuilder.processPreKeyBundle(retrievedPreKeyBundle);

  // 建立 SessionCipher，用於加密訊息
  final sessionCipher = SessionCipher(
      sessionStore, opkStore, spkStore, ipkStore, receiverAddress);

  // ciphertext 形態為 PreKeySignalMessage(prekeyType)
  final ciphertext =
      await sessionCipher.encrypt(Uint8List.fromList(utf8.encode(plainText)));
  final isPreKeySignalMessage =
      ciphertext.getType() == CiphertextMessage.prekeyType;
  ciphertext.getType() == CiphertextMessage.prekeyType;

  print('✨✨✨✨✨');
  print(
      '[encrypt_pre_key_signal_message] isPreKeySignalMessage: $isPreKeySignalMessage');
  print('✨✨✨✨✨');

  return (isPreKeySignalMessage, jsonEncode(ciphertext.serialize()));
}
