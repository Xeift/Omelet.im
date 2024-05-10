// 用於取得對方所有裝置和自己其他裝置可用的 one-time pre key index
import 'package:http/http.dart' as http;

import 'package:omelet/utils/server_uri.dart';
import 'package:omelet/storage/safe_account_store.dart';

Future<http.Response> getAvailableOpkIndexApi(
    String remoteUid, String deviceId) async {
  print('deviceId is : $deviceId');
  final token = await loadJwt();

  final res = await http.get(
      Uri.parse(
          '$serverUri/api/v1/get-available-opk-index?theirUid=$remoteUid&theirDeviceId=$deviceId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      });

  return res;
}
