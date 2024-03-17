// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import 'package:omelet/api/post/update_spk_api.dart';
import 'package:omelet/api/get/get_self_spk_status_api.dart';

import 'package:omelet/signal_protocol/safe_spk_store.dart';
import 'package:omelet/signal_protocol/safe_identity_store.dart';

Future<void> checkSpkStatus() async {
  final getSelfSpkStatusRes = await getSelfSpkStatusApi();
  final getSelfSpkStatusResBody = jsonDecode(getSelfSpkStatusRes.body);
  print('[main.dart] getSelfSpkStatusResBody: $getSelfSpkStatusResBody');
  final spkStatus = getSelfSpkStatusResBody['data'];
  final spkExpired = spkStatus['spkExpired'];
  final lastBatchSpkId = spkStatus['lastBatchSpkId'];

  if (spkExpired) {
    final ipkStore = SafeIdentityKeyStore();
    final selfIpk = await ipkStore.getIdentityKeyPair();
    final newSpk = generateSignedPreKey(selfIpk, lastBatchSpkId + 1);

    final res = await updateSpkApi(
      jsonEncode({
        newSpk.id.toString():
            jsonEncode(newSpk.getKeyPair().publicKey.serialize())
      }),
      jsonEncode({newSpk.id.toString(): jsonEncode(newSpk.signature)}),
    );
    print('[main.dart] 更新 SPK👉 ${res.body}');

    final spkStore = SafeSpkStore();
    await spkStore.storeSignedPreKey(newSpk.id, newSpk);
  }
}
