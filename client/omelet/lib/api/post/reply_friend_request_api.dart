// 同意或拒絕發給自身的好友邀請

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:omelet/utils/server_uri.dart';
import 'package:omelet/storage/safe_account_store.dart';

Future<http.Response> replyFriendRequestApi(
    String theirUid, bool isAgree) async {
  final token = await loadJwt();
  final res = await http.post(
    Uri.parse('$serverUri/api/v1/reply-friend-request'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode(
        <String, String>{'theirUid': theirUid, 'isAgree': isAgree.toString()}),
  );

  return res;
}
