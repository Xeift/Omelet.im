// 用於取得對方所有裝置和自己其他裝置可用的 one-time pre key index

import 'package:http/http.dart' as http;

import 'package:omelet/utils/load_local_info.dart';

Future<http.Response> getAvailableOpkIndexApi(String remoteUid) async {
  final (token, ipkPub) = await loadJwtAndIpkPub();

  final res = await http.get(
      Uri.parse(
          '$serverUri/api/v1/get-available-opk-index?uid=$remoteUid&ipkPub=$ipkPub'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      });

  return res;
}
