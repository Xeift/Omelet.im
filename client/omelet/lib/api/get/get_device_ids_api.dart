// 取得裝置 id

import 'package:http/http.dart' as http;

import 'package:omelet/utils/server_uri.dart';
import 'package:omelet/storage/safe_account_store.dart';

import 'package:omelet/storage/safe_device_id_store.dart';

Future<http.Response> getDeviceIdsApi() async {
  final token = await loadJwt();
  final safeDeviceIdStore = SafeDeviceIdStore();
  final ourDeviceId = await safeDeviceIdStore.getLocalDeviceId();

  final res = await http.get(
      Uri.parse('$serverUri/api/v1/get-device-ids?ourDeviceId=$ourDeviceId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      });

  return res;
}
