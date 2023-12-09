// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

// 註冊期
Future<void> install() async {
  print('aaaaaaaaaaaaaa');

  final ipk = generateIdentityKeyPair(); // 產生身份金鑰對（長期金鑰，平常不會動）
  final registrationId = generateRegistrationId(false); // 產生 UID
  // TODO: 正式部署時 UID 會透過後端伺服器產生，這裡的 ID 只用於測試
  final opks = generatePreKeys(0, 110); // 產生 OPK（短期金鑰，1 則訊息會用掉 1 個）
  // TODO: OPK 目前還在考慮一次產生多少組，未來可能不是 110
  final spk = generateSignedPreKey(ipk, 0); // 產生 SPK（中期金鑰，7 天更新一次）

  /* TODO:
  這裡我預計要自己 implement SessionStore、PreKeyStore、SignedPreKeyStore、IdentityKeyStore 這幾個 Interface
  改成用 flutter_secure_storge 存 session 和 OPK、SPK、IPK
  範例程式碼提供的 Class 只能用於測試，完全不適合部署
  */
  final sessionStore = InMemorySessionStore(); // 儲存 Session 的 Instance
  final opkStore = InMemoryPreKeyStore(); // 儲存 OPK 的 Instance
  final spkStore = InMemorySignedPreKeyStore(); // 儲存 SPK 的 Instance
  final identityStore =
      InMemoryIdentityKeyStore(ipk, registrationId); // 儲存 IPK 的 Instance

  for (final opk in opks) {
    await opkStore.storePreKey(opk.id, opk); // 儲存所有 OPK
  }
  await spkStore.storeSignedPreKey(spk.id, spk); // 儲存 SPK

  const bobAddress =
      SignalProtocolAddress('bob', 1); // 建立 Bob 的 Signal Protocol 地址

  final sessionBuilder = SessionBuilder(
      // 建立 session 用
      sessionStore,
      opkStore,
      spkStore,
      identityStore,
      bobAddress);

  // 模擬從伺服器取得 Pre Key Bundle
  /*TODO:
  到時候這裡會透過 API 
  GET https://omelet.im/get-pre-key-bundle 從後端拿某個特定 UID 的 Pre Key Bundle
  這個 API 後端還沒寫
  */
  final remoteRegId = generateRegistrationId(false);
  final remoteIPK = generateIdentityKeyPair();
  final remoteOPKs = generatePreKeys(0, 110);
  final remoteSPK = generateSignedPreKey(remoteIPK, 0);

  // 先建立 Pre Key Bundle，準備等等用於建立 Session
  final retrievedPreKey = PreKeyBundle(
      remoteRegId,
      1,
      remoteOPKs[0].id,
      remoteOPKs[0].getKeyPair().publicKey,
      remoteSPK.id,
      remoteSPK.getKeyPair().publicKey,
      remoteSPK.signature,
      remoteIPK.getPublicKey());

  await sessionBuilder.processPreKeyBundle(
      retrievedPreKey); // 用 sessionBuilder 處理 Pre Key Bundle 並建立 Session

  final sessionCipher = SessionCipher(
      // 建立 sessionCipher，用於加解密訊息
      sessionStore,
      opkStore,
      spkStore,
      identityStore,
      bobAddress);

  final ciphertext = await sessionCipher // 用 sessionCipher 加密訊息
      .encrypt(
          Uint8List.fromList(utf8.encode("嗨 Bob 我是 Alice\n透過 Omelet.im 傳送")));

  print(ciphertext.serialize()); // 印出 serialize 過的加密訊息

  // TODO: 這裡會使用 socket_io_client 傳送加密訊息，並透過後端伺服器轉發訊息到 Bob 的客戶端
  // 以下是模擬 Bob 的客戶端接收訊息並解密的邏輯

  final signalProtocolStore = InMemorySignalProtocolStore(remoteIPK, 1);
  const aliceAddress =
      SignalProtocolAddress('alice', 1); // 建立 Alice 的 Signal Protocol 地址
  final remoteSessionCipher = SessionCipher.fromStore(
      signalProtocolStore, aliceAddress); // 建立 sessionCipher，用於加解密訊息

  for (final remoteOPK in remoteOPKs) {
    await signalProtocolStore.storePreKey(remoteOPK.id, remoteOPK); // 儲存所有 OPK
  }
  await signalProtocolStore.storeSignedPreKey(remoteSPK.id, remoteSPK);

  if (ciphertext.getType() == CiphertextMessage.prekeyType) {
    // 如果加密訊息的類型是 Pre Key，則使用 remoteSessionCipher 解密訊息
    await remoteSessionCipher
        .decryptWithCallback(ciphertext as PreKeySignalMessage, (plaintext) {
      print(utf8.decode(plaintext)); // 印出明文訊息
    });
  }
}
