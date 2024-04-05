// 用於下載對方所有裝置和自己其他裝置的 PreKeyBundle

import 'package:http/http.dart' as http;

import 'package:omelet/utils/load_local_info.dart';

Future<http.Response> downloadPreKeyBundleApi(
    String remoteUid, String multiDevicesOpkIndexesRandom) async {
  final token = await loadJwt();

  final res = await http.get(
      Uri.parse(
          '$serverUri/api/v1/download-pre-key-bundle?uid=$remoteUid&multiDevicesOpkIndexesRandom=$multiDevicesOpkIndexesRandom'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      });

  return res;
}
