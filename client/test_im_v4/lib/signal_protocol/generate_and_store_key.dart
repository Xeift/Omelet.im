// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import 'safe_spk_store.dart';
import 'safe_opk_store.dart';
import 'safe_identity_store.dart';
import './../api/post/upload_pre_key_bundle_api.dart';

Future<void> generateAndStoreKey() async {
  final registrationId = generateRegistrationId(false);
  final selfIpk = generateIdentityKeyPair(); // 產生 IPK（長期金鑰對，平常不會動）
  final selfSpk = generateSignedPreKey(selfIpk, 0); // 產生 SPK（中期金鑰對，每 7 天更新一次）
  final selfOpks = generatePreKeys(0, 100); // 產生 OPK（短期金鑰對，1 則 Session 會用掉 1 個）

  final ipkStore = SafeIdentityKeyStore();
  await ipkStore.saveIdentityKeyPair(selfIpk, registrationId);
  final spkStore = SafeSpkStore();
  await spkStore.storeSignedPreKey(0, selfSpk);
  final opkStore = SafeOpkStore();
  for (final selfOpk in selfOpks) {
    await opkStore.storePreKey(selfOpk.id, selfOpk);
  }

  const deviceId = '0';

  await uploadPreKeyBundleAPI(
      deviceId,
      jsonEncode(selfIpk.getPublicKey().serialize()),
      jsonEncode({
        selfSpk.id.toString():
            jsonEncode(selfSpk.getKeyPair().publicKey.serialize())
      }),
      jsonEncode({selfSpk.id.toString(): jsonEncode(selfSpk.signature)}),
      jsonEncode({
        for (var selfOpk in selfOpks)
          selfOpk.id.toString():
              jsonEncode(selfOpk.getKeyPair().publicKey.serialize())
      }));
}
