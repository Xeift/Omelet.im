// 透過 uid 或使用者名稱發好友邀請

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:omelet/utils/load_local_info.dart';

Future<http.Response> sendFriendRequestApi(
    String theirIdentifier, String type) async {
  final token = await loadJwt();
  final res = await http.post(
    Uri.parse('$serverUri/api/v1/send-friend-request'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode(
        <String, String>{'theirIdentifier': theirIdentifier, 'type': type}),
  );

  return res;
}
