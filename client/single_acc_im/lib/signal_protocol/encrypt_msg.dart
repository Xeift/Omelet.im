import 'dart:convert';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import './../signal_protocol/safe_spk_store.dart';
import './../signal_protocol/safe_opk_store.dart';
import './../signal_protocol/safe_session_store.dart';
import './../signal_protocol/safe_identity_store.dart';

Future<String> encryptMsg(
    IdentityKey ipkPub,
    ECPublicKey spkPub,
    Uint8List spkSig,
    ECPublicKey opkPub,
    int spkId,
    int opkId,
    String remoteUid,
    String msgContent,
    Function updateHintMsg) async {
  final ipkStore = SafeIdentityKeyStore();
  final registrationId = await ipkStore.getLocalRegistrationId();
  final spkStore = SafeSpkStore();
  final opkStore = SafeOpkStore();
  final remoteAddress = SignalProtocolAddress(remoteUid.toString(), 1);

  // 建立 SessionStore
  final sessionStore = SafeSessionStore();
  final sessionBuilder =
      SessionBuilder(sessionStore, opkStore, spkStore, ipkStore, remoteAddress);

  // 用 sessionBuilder 處理 PreKeyBundle
  final retrievedPreKeyBundle = PreKeyBundle(
      registrationId, 1, opkId, opkPub, spkId, spkPub, spkSig, ipkPub);
  await sessionBuilder.processPreKeyBundle(retrievedPreKeyBundle);

  // 建立 SessionCipher，用於加密訊息
  final sessionCipher =
      SessionCipher(sessionStore, opkStore, spkStore, ipkStore, remoteAddress);
  final ciphertext =
      await sessionCipher.encrypt(Uint8List.fromList(utf8.encode(msgContent)));

  return jsonEncode(ciphertext.serialize());
}
