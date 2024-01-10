import 'dart:convert';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import 'safe_identity_store.dart';
import 'safe_spk_store.dart';
import 'safe_opk_store.dart';
import 'safe_session_store.dart';

Future<void> install() async {
  // 自己的資訊
  const selfUid = 1234567;
  final selfAddress =
      SignalProtocolAddress(selfUid.toString(), 1); // Signal protocol 地址
  final selfIpk = generateIdentityKeyPair(); // 產生身份金鑰對（長期金鑰對，平常不會動）
  final selfSpk = generateSignedPreKey(selfIpk, 0); // 產生 SPK（中期金鑰對，每 7 天更新一次）
  final selfOpks = generatePreKeys(0, 110); // 產生 OPK（短期金鑰對，1 則訊息會用掉 1 個）

  final ipkStore = SafeIdentityKeyStore();
  await ipkStore.saveIdentityKeyPair(selfIpk, selfUid);
  final spkStore = SafeSpkStore();
  await spkStore.storeSignedPreKey(0, selfSpk);
  final opkStore = SafeOpkStore();
  for (final selfOpk in selfOpks) {
    await opkStore.storePreKey(selfOpk.id, selfOpk);
  }

  // Bob 的資訊
  const remoteUid = 7654321;
  final remoteAddress = SignalProtocolAddress(remoteUid.toString(), 1);
  final remoteIpk = generateIdentityKeyPair();
  final remoteSpk = generateSignedPreKey(remoteIpk, 0);
  final remoteOpks = generatePreKeys(0, 110);

  // 建立 SessionStore
  final sessionStore = SafeSessionStore();
  final sessionBuilder =
      SessionBuilder(sessionStore, opkStore, spkStore, ipkStore, remoteAddress);

  // 用 sessionBuilder 處理 PreKeyBundle
  final retrievedPreKeyBundle = PreKeyBundle(
      remoteUid,
      1,
      remoteOpks[0].id,
      remoteOpks[0].getKeyPair().publicKey,
      remoteSpk.id,
      remoteSpk.getKeyPair().publicKey,
      remoteSpk.signature,
      remoteIpk.getPublicKey());
  await sessionBuilder.processPreKeyBundle(retrievedPreKeyBundle);

  // 建立 SessionCipher，用於加密訊息
  final sessionCipher =
      SessionCipher(sessionStore, opkStore, spkStore, ipkStore, remoteAddress);
  final ciphertext = await sessionCipher
      .encrypt(Uint8List.fromList(utf8.encode('Hello Omelet.im 😎')));
  print(ciphertext);
  print(ciphertext.serialize());

  // 模擬建立 Bob 的 SessionCipher，用於解密訊息
  final signalProtocolStore = InMemorySignalProtocolStore(remoteIpk, 1);
  final remoteSessionCipher =
      SessionCipher.fromStore(signalProtocolStore, selfAddress);

  // 模擬儲存 Bob 的 OPK 和 SPK
  for (final remoteOpk in remoteOpks) {
    await signalProtocolStore.storePreKey(remoteOpk.id, remoteOpk);
  }
  await signalProtocolStore.storeSignedPreKey(remoteSpk.id, remoteSpk);

  // 解密訊息
  if (ciphertext.getType() == CiphertextMessage.prekeyType) {
    await remoteSessionCipher
        .decryptWithCallback(ciphertext as PreKeySignalMessage, (plaintext) {
      print(utf8.decode(plaintext));
    });
  }
}
