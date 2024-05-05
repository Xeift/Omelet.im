// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

// 將下載的 PreKeyBundle 形態轉換為函式庫可使用的形態
Future<(IdentityKey, ECPublicKey, Uint8List, ECPublicKey, int, int)>
    preKeyBundleTypeConverter(
        String deviceId, Map<String, dynamic> singlePreKeyBundle) async {
  final ipkPub = IdentityKey.fromBytes(
      Uint8List.fromList(
          jsonDecode(singlePreKeyBundle['ipkPub']).cast<int>().toList()),
      0);
  final spkPub = Curve.decodePoint(
      Uint8List.fromList(
          jsonDecode(singlePreKeyBundle['spkPub']).cast<int>().toList()),
      0);
  final spkSig = Uint8List.fromList(
      jsonDecode(singlePreKeyBundle['spkSig']).cast<int>().toList());
  final opkPub = Curve.decodePoint(
      Uint8List.fromList(
          (jsonDecode(singlePreKeyBundle['opkPub'])).cast<int>().toList()),
      0);
  final spkId = int.parse(singlePreKeyBundle['spkId']);
  final opkId = singlePreKeyBundle['opkId'] as int;

  return (ipkPub, spkPub, spkSig, opkPub, spkId, opkId);
}
