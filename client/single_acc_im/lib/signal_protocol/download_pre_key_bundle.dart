import 'dart:math';
import 'dart:convert';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import '../api/get/download_pre_key_bundle_api.dart';
import '../api/get/get_available_opk_index.dart';

Future<(IdentityKey, ECPublicKey, Uint8List, ECPublicKey, int, int)>
    downloadPreKeyBundle(String receiverId) async {
  final opkIndexRes = await getAvailableOpkIndex(receiverId);
  print('opkindexres   ${opkIndexRes.body}');
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
  final spkId = preKeyBundle['spkId'];

  return (ipkPub, spkPub, spkSig, opkPub, int.parse(spkId), int.parse(opkId));
}

T randomChoice<T>(List<T> list) {
  var random = Random();
  return list[random.nextInt(list.length)];
}
