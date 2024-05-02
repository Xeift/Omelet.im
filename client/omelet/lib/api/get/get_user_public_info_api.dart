// 取得使用者公開資訊，包括 uid、使用者名稱、頭像

import 'package:http/http.dart' as http;

import 'package:omelet/utils/server_uri.dart';
import 'package:omelet/storage/safe_account_store.dart';

Future<http.Response> getUserPublicInfoApi(uid) async {
  final token = await loadJwt();

  final res = await http.get(
      Uri.parse('$serverUri/api/v1/get-user-public-info?uid=$uid'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      });

  return res;
}
