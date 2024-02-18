// ignore_for_file: avoid_print

import 'dart:math';
import 'dart:convert';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import './../api/get/download_pre_key_bundle_api.dart';
import './../api/get/get_available_opk_index_api.dart';

Future<(IdentityKey, ECPublicKey, Uint8List, ECPublicKey, int, int)>
    downloadPreKeyBundle(String remoteUid) async {
  final multiDevicesOpkIndexesRes = await getAvailableOpkIndexApi(remoteUid);
  final multiDevicesOpkIndexesResBody =
      jsonDecode(multiDevicesOpkIndexesRes.body);

  print('多裝置 opkId 內容👉$multiDevicesOpkIndexesResBody');

  final opkId = randomChoice(multiDevicesOpkIndexesResBody['data']);

  final res = await downloadPreKeyBundleAPI(remoteUid, opkId);
  final multiDevicesPreKeyBundle = jsonDecode(res.body)['data'];
  print('[download_pre_key_bundle.dart] pkb 內容👉 ${res.body}');
  print('[download_pre_key_bundle.dart] pkb 形態👉 ${res.body.runtimeType}');

  final ipkPub = IdentityKey.fromBytes(
      Uint8List.fromList(
          jsonDecode(multiDevicesPreKeyBundle['ipkPub']).cast<int>().toList()),
      0);
  final spkPub = Curve.decodePoint(
      Uint8List.fromList(
          jsonDecode(multiDevicesPreKeyBundle['spkPub']).cast<int>().toList()),
      0);
  final spkSig = Uint8List.fromList(
      jsonDecode(multiDevicesPreKeyBundle['spkSig']).cast<int>().toList());
  final opkPub = Curve.decodePoint(
      Uint8List.fromList((jsonDecode(multiDevicesPreKeyBundle['opkPub']))
          .cast<int>()
          .toList()),
      0);
  final spkId = multiDevicesPreKeyBundle['spkId'];

  return (ipkPub, spkPub, spkSig, opkPub, int.parse(spkId), int.parse(opkId));
}

T randomChoice<T>(List<T> list) {
  var random = Random();
  return list[random.nextInt(list.length)];
}
