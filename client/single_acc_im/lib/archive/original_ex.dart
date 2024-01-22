// 引入所需的庫
// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

// 主函數
Future<void> main() async {
  await install(); // 呼叫 install 函數
}

// install 函數用於生成並存儲身份鍵對、註冊 ID、預鍵和簽名預鍵
Future<void> install() async {
  final identityKeyPair = generateIdentityKeyPair(); // 生成身份鍵對
  final registrationId = generateRegistrationId(false); // 生成註冊 ID

  final preKeys = generatePreKeys(0, 110); // 生成預鍵

  final signedPreKey = generateSignedPreKey(identityKeyPair, 0); // 生成簽名預鍵

  // 創建存儲
  final sessionStore = InMemorySessionStore();
  final preKeyStore = InMemoryPreKeyStore();
  final signedPreKeyStore = InMemorySignedPreKeyStore();
  final identityStore =
      InMemoryIdentityKeyStore(identityKeyPair, registrationId);

  // 存儲預鍵和簽名預鍵
  for (final p in preKeys) {
    await preKeyStore.storePreKey(p.id, p);
  }
  await signedPreKeyStore.storeSignedPreKey(signedPreKey.id, signedPreKey);

  // 創建一個 SessionBuilder 來建立新的會話
  const bobAddress = SignalProtocolAddress('bob', 1);
  final sessionBuilder = SessionBuilder(
      sessionStore, preKeyStore, signedPreKeyStore, identityStore, bobAddress);

  // 應從服務器獲取遠程預鍵
  final remoteRegId = generateRegistrationId(false);
  final remoteIdentityKeyPair = generateIdentityKeyPair();
  final remotePreKeys = generatePreKeys(0, 110);
  final remoteSignedPreKey = generateSignedPreKey(remoteIdentityKeyPair, 0);

  // 創建一個 PreKeyBundle 來表示從服務器檢索到的預鍵
  final retrievedPreKey = PreKeyBundle(
      remoteRegId,
      1,
      remotePreKeys[0].id,
      remotePreKeys[0].getKeyPair().publicKey,
      remoteSignedPreKey.id,
      remoteSignedPreKey.getKeyPair().publicKey,
      remoteSignedPreKey.signature,
      remoteIdentityKeyPair.getPublicKey());

  // 使用 PreKeyBundle 來處理預鍵包並建立會話
  await sessionBuilder.processPreKeyBundle(retrievedPreKey);

  // 創建一個 SessionCipher 來加密和解密訊息
  final sessionCipher = SessionCipher(
      sessionStore, preKeyStore, signedPreKeyStore, identityStore, bobAddress);
  final ciphertext = await sessionCipher
      .encrypt(Uint8List.fromList(utf8.encode('Hello Mixin🤣'))); // 加密訊息
  print(ciphertext); // 打印密文
  print(ciphertext.serialize()); // 打印序列化的密文

  // 創建一個遠程 SessionCipher 來解密訊息
  final signalProtocolStore =
      InMemorySignalProtocolStore(remoteIdentityKeyPair, 1);
  const aliceAddress = SignalProtocolAddress('alice', 1);
  final remoteSessionCipher =
      SessionCipher.fromStore(signalProtocolStore, aliceAddress);

  // 存儲遠程預鍵和簽名預鍵
  for (final p in remotePreKeys) {
    await signalProtocolStore.storePreKey(p.id, p);
  }
  await signalProtocolStore.storeSignedPreKey(
      remoteSignedPreKey.id, remoteSignedPreKey);

  // 解密訊息
  if (ciphertext.getType() == CiphertextMessage.prekeyType) {
    await remoteSessionCipher
        .decryptWithCallback(ciphertext as PreKeySignalMessage, (plaintext) {
      print(utf8.decode(plaintext)); // 打印解密後的明文
    });
  }
}
