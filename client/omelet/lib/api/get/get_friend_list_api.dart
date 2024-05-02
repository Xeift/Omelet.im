// 取得好友列表

import 'package:http/http.dart' as http;

import 'package:omelet/utils/server_uri.dart';
import 'package:omelet/storage/safe_account_store.dart';

Future<http.Response> getFriendListApi() async {
  final token = await loadJwt();

  final res = await http.get(Uri.parse('$serverUri/api/v1/get-friend-list'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      });

  return res;
}
