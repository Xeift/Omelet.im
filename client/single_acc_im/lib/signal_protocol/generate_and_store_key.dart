import 'dart:convert';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'safe_identity_store.dart';
import 'safe_spk_store.dart';
import 'safe_opk_store.dart';
import './../api/post/upload_keys_api.dart';

Future<void> generateAndStoreKey() async {
  const storage = FlutterSecureStorage();

  final selfUid = int.parse((await storage.read(key: 'uid')).toString());
  final selfIpk = generateIdentityKeyPair(); // 產生 IPK（長期金鑰對，平常不會動）
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

  const deviceId = '1';

  final res = await uploadKeysAPI(
      deviceId,
      jsonEncode(selfIpk.getPublicKey().serialize()),
      jsonEncode(selfSpk.getKeyPair().publicKey.serialize()),
      jsonEncode(selfSpk.signature),
      jsonEncode({
        for (var selfOpk in selfOpks)
          selfOpk.id.toString():
              jsonEncode(selfOpk.getKeyPair().publicKey.serialize())
      }));
}
