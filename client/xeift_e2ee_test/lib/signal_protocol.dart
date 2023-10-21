// ignore_for_file: avoid_print

import 'dart:convert'; // 用於編碼和解碼字串
import 'dart:typed_data'; // 用於處理字節數組
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart'; // 用於實現信號協議
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'safe_pre_key_store.dart';
import 'login_api.dart';
import 'package:flutter/src/widgets/framework.dart';

Future<void> install() async {
  final identityKeyPair = generateIdentityKeyPair(); // 生成身份金鑰對
  final registrationId = generateRegistrationId(false); // 生成註冊ID
  final preKeys = generatePreKeys(0, 110); // 生成預先金鑰列表
  final signedPreKey = generateSignedPreKey(identityKeyPair, 0); // 生成簽名預先金鑰

  print('-------------------------   debug 內容開始   -------------------------');
  print(
      '[signal_protocol.dart] identityKeyPair 內容： ${identityKeyPair.serialize()}'); // need to serialize
  print('[signal_protocol.dart] registrationId 內容： $registrationId');
  print(
      '[signal_protocol.dart] preKeys 內容： ${preKeys[0].serialize()}'); // need to serialize
  print(
      '[signal_protocol.dart] signedPreKey 內容： ${signedPreKey.serialize()}'); // need to serialize

  final sessionStore = InMemorySessionStore(); // 建立會話儲存方式
  // final preKeyStore = InMemoryPreKeyStore(); // 建立預先金鑰儲存方式
  final preKeyStore = InMemoryPreKeyStore(); // 建立預先金鑰儲存方式
  final signedPreKeyStore = InMemorySignedPreKeyStore(); // 建立簽名預先金鑰儲存方式
  final identityStore =
      InMemoryIdentityKeyStore(identityKeyPair, registrationId); // 建立身份金鑰儲存方式

  // 將預先金鑰和簽名預先金鑰儲存在對應的儲存方式中
  for (final p in preKeys) {
    await preKeyStore.storePreKey(p.id, p);
  }
  await signedPreKeyStore.storeSignedPreKey(signedPreKey.id, signedPreKey);

  const bobAddress = SignalProtocolAddress('bob', 1); // 建立bob的信號協議地址
  final sessionBuilder = SessionBuilder(
      // 建立會話建立器，用於處理預先金鑰包和建立會話
      sessionStore,
      preKeyStore,
      signedPreKeyStore,
      identityStore,
      bobAddress);

  // 模擬從伺服器獲取遠端的預先金鑰包，包括遠端的註冊ID、身份公鑰、預先公鑰和簽名預先公鑰等資訊
  final remoteRegId = generateRegistrationId(false);
  final remoteIdentityKeyPair = generateIdentityKeyPair();
  final remotePreKeys = generatePreKeys(0, 110);
  final remoteSignedPreKey = generateSignedPreKey(remoteIdentityKeyPair, 0);

  // 建立預先金鑰包物件，用於與遠端建立會話
  final retrievedPreKey = PreKeyBundle(
      remoteRegId,
      1,
      remotePreKeys[0].id,
      remotePreKeys[0].getKeyPair().publicKey,
      remoteSignedPreKey.id,
      remoteSignedPreKey.getKeyPair().publicKey,
      remoteSignedPreKey.signature,
      remoteIdentityKeyPair.getPublicKey());

  await sessionBuilder
      .processPreKeyBundle(retrievedPreKey); // 使用會話建立器處理預先金鑰包，建立會話

  final sessionCipher = SessionCipher(
      // 建立會話密碼器，用於加密和解密訊息
      sessionStore,
      preKeyStore,
      signedPreKeyStore,
      identityStore,
      bobAddress);

  final ciphertext = await sessionCipher // 使用會話密碼器加密訊息，得到密文物件
      .encrypt(Uint8List.fromList(utf8.encode('Hello Mixin🤣')));

  // print(ciphertext); // 印出密文物件的資訊
  // print(ciphertext.serialize()); // 印出密文物件的序列化字節數組

  //deliver(ciphertext); // 將密文物件傳送給遠端

  // 模擬遠端的信號協議儲存方式，用於儲存遠端的身份金鑰、預先金鑰、簽名預先金鑰等資訊
  final signalProtocolStore =
      InMemorySignalProtocolStore(remoteIdentityKeyPair, 1);
  const aliceAddress = SignalProtocolAddress('alice', 1); // 建立alice的信號協議地址
  final remoteSessionCipher =
      SessionCipher.fromStore(signalProtocolStore, aliceAddress); // 建立遠端的會話密碼器

  // 將遠端的預先金鑰和簽名預先金鑰儲存在對應的儲存方式中
  for (final p in remotePreKeys) {
    await signalProtocolStore.storePreKey(p.id, p);
  }
  await signalProtocolStore.storeSignedPreKey(
      remoteSignedPreKey.id, remoteSignedPreKey);

  if (ciphertext.getType() == CiphertextMessage.prekeyType) {
    // 如果密文物件是預先金鑰訊息類型，則使用遠端的會話密碼器解密訊息，並提供回呼函數處理明文
    await remoteSessionCipher
        .decryptWithCallback(ciphertext as PreKeySignalMessage, (plaintext) {
      // print(utf8.decode(plaintext)); // 印出明文的字串
    });
  }
  print('-------------------------   debug 內容結束   -------------------------\n');
}

Future<void> onWriteBtnPressed(String key, String value) async {
  print('write');
  print('$key $value');
  const storage = FlutterSecureStorage();
  await storage.write(key: key, value: value);
}

Future<void> onWriteJsonBtnPressed() async {
  print('write json');
  const storage = FlutterSecureStorage();
  final mp = {
    "1": jsonEncode(Uint8List.fromList([
      8,
      0,
      18,
      33,
      5,
      228,
      236,
      194,
      131,
      236,
      141,
      85,
      50,
      237,
      231,
      62,
      31,
      45,
      92,
      207,
      47,
      117,
      13,
      189,
      189,
      162,
      94,
      37,
      15,
      81,
      119,
      133,
      74,
      59,
      124,
      148,
      102,
      26,
      32,
      176,
      43,
      202,
      119,
      190,
      25,
      178,
      221,
      110,
      127,
      162,
      173,
      223,
      74,
      188,
      161,
      186,
      173,
      239,
      203,
      216,
      96,
      253,
      228,
      175,
      66,
      23,
      100,
      137,
      90,
      191,
      109
    ])),
    "2": jsonEncode(Uint8List.fromList([
      8,
      1,
      18,
      33,
      5,
      103,
      198,
      162,
      44,
      148,
      68,
      65,
      113,
      71,
      193,
      134,
      167,
      41,
      166,
      225,
      160,
      162,
      96,
      203,
      151,
      113,
      226,
      84,
      183,
      37,
      46,
      82,
      144,
      238,
      98,
      225,
      123,
      26,
      32,
      104,
      225,
      51,
      209,
      98,
      176,
      189,
      86,
      233,
      209,
      52,
      66,
      76,
      212,
      171,
      110,
      209,
      236,
      67,
      61,
      95,
      9,
      72,
      0,
      139,
      44,
      73,
      57,
      141,
      187,
      125,
      112
    ])),
  };
  await storage.write(key: 'preKey', value: jsonEncode(mp)); //
}

Future<void> onRemoveBtnPressed(String key) async {
  print('remove');
  print(key);
  const storage = FlutterSecureStorage();
  await storage.delete(key: key);
}

Future<void> onRemoveAllBtnPressed() async {
  print('remove all');
  const storage = FlutterSecureStorage();
  await storage.deleteAll();
}

Future<void> onLoadPreKeyBtnPressed(String id) async {
  final preKeyStore =
      SafePreKeyStore(const FlutterSecureStorage()); // 建立預先金鑰儲存方式
  final x = await preKeyStore.loadPreKey(int.parse(id));
  print('x: ${x.serialize()}');
}

Future<void> onContainsPreKeyBtnPressed(String id) async {
  final preKeyStore =
      SafePreKeyStore(const FlutterSecureStorage()); // 建立預先金鑰儲存方式
  final x = await preKeyStore.containsPreKey(int.parse(id));
  print('x: $x');
}

Future<void> onRemovePreKeyBtnPressed(String id) async {
  final preKeyStore =
      SafePreKeyStore(const FlutterSecureStorage()); // 建立預先金鑰儲存方式
  await preKeyStore.removePreKey(int.parse(id));
}

Future<void> onStorePreKeyBtnPressed() async {
  final preKeyStore =
      SafePreKeyStore(const FlutterSecureStorage()); // 建立預先金鑰儲存方式

  final preKeys = generatePreKeys(0, 110); // 生成預先金鑰列表

  for (final p in preKeys) {
    await preKeyStore.storePreKey(p.id, p);
  }
}

Future<void> onStoreJWTBtnPressed(String acc, String pwd) async {
  print('storeJWTBtnPressed-----------');
  final storage = new FlutterSecureStorage();
  final res = await loginAPI(acc, pwd);
  final resBody = jsonDecode(res.body);
  await storage.write(key: 'token', value: resBody['token']);
}

Future<void> onGenerateKeyBtnPressed() async {
  final identityKeyPair = generateIdentityKeyPair(); // 生成身份金鑰對
  final registrationId = generateRegistrationId(false); // 生成註冊ID
  final preKeys = generatePreKeys(0, 110); // 生成預先金鑰列表
  final signedPreKey = generateSignedPreKey(identityKeyPair, 0); // 生成簽名預先金鑰

  final preKeyStore = SafePreKeyStore(const FlutterSecureStorage());

  for (final p in preKeys) {
    print('${p.id}                ${p.serialize()}');
    await preKeyStore.storePreKey(p.id, p);
  }

  print('儲存完畢');

  // print('-------------------------   debug 內容開始   -------------------------');
  // print(
  //     '[signal_protocol.dart] identityKeyPair 內容： ${identityKeyPair.serialize().runtimeType}'); // need to serialize
  // print(
  //     '[signal_protocol.dart] registrationId 內容： ${registrationId.toString().runtimeType}');
  // print(
  //     '[signal_protocol.dart] preKeys 內容： ${preKeys[0].serialize().runtimeType}'); // need to serialize
  // print(
  //     '[signal_protocol.dart] signedPreKey 內容： ${signedPreKey.serialize().runtimeType}'); // need to serialize
  // print('-------------------------   debug 內容結束   -------------------------');
}
