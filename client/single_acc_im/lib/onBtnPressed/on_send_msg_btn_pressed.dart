import 'dart:convert';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import '../api/get/download_pre_key_bundle_api.dart';

Future<void> onSendMsgBtnPressed(
    String receiverId, String msgContent, Function updateHintMsg) async {
  final res = await downloadPreKeyBundleAPI(receiverId);
  final preKeyBundle = jsonDecode(res.body)['data'];
  print(preKeyBundle);
  // TODO: 取ID取OPK
  const opkId = '5';
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
          (jsonDecode(preKeyBundle['opkPub'][opkId])).cast<int>().toList()),
      0);

  print(preKeyBundle);
  print(preKeyBundle.runtimeType);
}
