// 取得所有傳送給自己的未讀訊息

import 'package:http/http.dart' as http;

import 'package:omelet/utils/server_uri.dart';
import 'package:omelet/storage/safe_account_store.dart';
import 'package:omelet/storage/safe_device_id_store.dart';

Future<http.Response> getUnreadMsgApi() async {
  final token = await loadJwt();
  final safeDeviceIdStore = SafeDeviceIdStore();
  final deviceId = await safeDeviceIdStore.getLocalDeviceId();

  final res = await http.get(
      Uri.parse('$serverUri/api/v1/get-unread-msg?deviceId=$deviceId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      });

  return res;
}
