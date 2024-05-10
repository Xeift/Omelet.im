import 'dart:convert';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import 'package:omelet/api/post/update_opk_api.dart';
import 'package:omelet/api/get/get_self_opk_status_api.dart';
import 'package:omelet/signal_protocol/safe_opk_store.dart';

Future<void> checkOpkStatus() async {
  final getSelfOpkStatusRes = await getSelfOpkStatusApi();
  final getSelfOpkStatusResBody = jsonDecode(getSelfOpkStatusRes.body);

  final outOfOpk = getSelfOpkStatusResBody['data']['outOfOpk'];
  final lastBatchMaxOpkId =
      getSelfOpkStatusResBody['data']['lastBatchMaxOpkId'];

  if (outOfOpk) {
    final newOpks = generatePreKeys(lastBatchMaxOpkId + 1, 100);

    await updateOpkApi(jsonEncode({
      for (var newOpk in newOpks)
        newOpk.id.toString():
            jsonEncode(newOpk.getKeyPair().publicKey.serialize())
    }));

    final opkStore = SafeOpkStore();
    for (final newOpk in newOpks) {
      await opkStore.storePreKey(newOpk.id, newOpk);
    }
  }
}
