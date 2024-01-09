import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import 'safe_identity_store.dart';

Future<void> install() async {
  final ipk = generateIdentityKeyPair(); // 產生身份金鑰對（長期金鑰對，平常不會動）
  final spk = generateSignedPreKey(ipk, 0); // 產生 SPK（中期金鑰對，每 7 天更新一次）
  final opks = generatePreKeys(0, 110); // 產生 OPK（短期金鑰對，1 則訊息會用掉 1 個）
  const uid = 1234567; // uid
  final address = SignalProtocolAddress(uid.toString(), 0); // SG 地址

  final ipkStore = SafeIdentityKeyStore(ipk, uid);
}
