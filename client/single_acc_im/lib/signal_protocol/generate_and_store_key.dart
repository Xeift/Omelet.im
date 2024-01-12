import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import 'safe_identity_store.dart';
import 'safe_spk_store.dart';
import 'safe_opk_store.dart';

Future<void> install() async {
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
}
