import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'safe_identity_store.dart';
import 'safe_spk_store.dart';
import 'safe_opk_store.dart';
import './../utils/server_uri.dart';

Future<void> generateAndStoreKey() async {
  const storage = FlutterSecureStorage();

  final selfUid = int.parse((await storage.read(key: 'uid')).toString());
  // final selfAddress =
  //     SignalProtocolAddress(selfUid.toString(), 1); // Signal protocol 地址
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

  final res = await http.post(Uri.parse('$serverUri/api/v1/upload-keys'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${await storage.read(key: 'token')}'
      },
      body: jsonEncode(<String, String>{
        'deviceId': '1',
        'ipkPub': jsonEncode(selfIpk.getPublicKey().serialize()),
        'spkPub': jsonEncode(selfSpk.getKeyPair().publicKey.serialize()),
        'spkSig': jsonEncode(selfSpk.signature),
        'opkPub': jsonEncode({
          for (var selfOpk in selfOpks)
            selfOpk.id.toString():
                jsonEncode(selfOpk.getKeyPair().publicKey.serialize())
        }),
      }));
  final resBody = jsonDecode(res.body);
  print(resBody);
}
