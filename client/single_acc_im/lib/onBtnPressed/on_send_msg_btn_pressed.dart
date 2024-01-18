import 'dart:math';
import 'dart:convert';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import '../api/get/download_pre_key_bundle_api.dart';
import '../api/get/get_available_opk_index.dart';

Future<void> onSendMsgBtnPressed(
    String receiverId, String msgContent, Function updateHintMsg) async {
  final opkIndexRes = await getAvailableOpkIndex(receiverId);
  final opkId = randomChoice(jsonDecode(opkIndexRes.body)['data']);

  final res = await downloadPreKeyBundleAPI(receiverId, opkId);
  final preKeyBundle = jsonDecode(res.body)['data'];

  final ipkPub = IdentityKey.fromBytes(
      Uint8List.fromList(
          jsonDecode(preKeyBundle['ipkPub']).cast<int>().toList()),
      0);
  final spkPub = Curve.decodePoint(
      Uint8List.fromList(
          jsonDecode(preKeyBundle['spkPub']).cast<int>().toList()),
      0);
  final spkSig = Uint8List.fromList(
      jsonDecode(preKeyBundle['spkSig']).cast<int>().toList());
  final opkPub = Curve.decodePoint(
      Uint8List.fromList(
          (jsonDecode(preKeyBundle['opkPub'])).cast<int>().toList()),
      0);

  print(opkId);
  print(opkPub.serialize());
}

T randomChoice<T>(List<T> list) {
  var random = Random();
  return list[random.nextInt(list.length)];
}
