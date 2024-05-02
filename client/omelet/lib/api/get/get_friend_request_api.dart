// 取得發給自己的所有好友邀請

import 'package:http/http.dart' as http;

import 'package:omelet/storage/safe_account_store.dart';
import 'package:omelet/utils/server_uri.dart';

Future<http.Response> getFriendRequestApi() async {
  final token = await loadJwt();

  final res = await http.get(Uri.parse('$serverUri/api/v1/get-friend-request'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      });

  return res;
}
