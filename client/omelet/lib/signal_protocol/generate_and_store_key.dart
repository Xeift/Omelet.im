import 'dart:convert';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:omelet/signal_protocol/safe_spk_store.dart';
import 'package:omelet/signal_protocol/safe_opk_store.dart';
import 'package:omelet/signal_protocol/safe_identity_store.dart';
import 'package:omelet/api/post/upload_pre_key_bundle_api.dart';
import 'package:omelet/storage/safe_device_id_store.dart';
import 'package:omelet/storage/safe_account_store.dart';

Future<bool> isPreKeyBundleExists() async {
  const storage = FlutterSecureStorage();
  final ourCurrentUid = await loadCurrentActiveAccount();
  final hasIpk = await storage.read(key: '${ourCurrentUid}_selfIpk');
  if (hasIpk == null) {
    return false;
  }

  return true;
}

Future<void> generateAndStoreKey() async {
  if (await isPreKeyBundleExists()) {
    return;
  }

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

  final res = await uploadPreKeyBundleApi(
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

  final deviceId = jsonDecode(res.body)['data']['deviceId'].toString();
  final safeDeviceIdStore = SafeDeviceIdStore();
  await safeDeviceIdStore.writeLocalDeviceId(deviceId);
}
