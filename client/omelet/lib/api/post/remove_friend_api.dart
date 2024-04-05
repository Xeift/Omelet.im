// 透過 uid 移除特定好友

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:omelet/utils/load_local_info.dart';

Future<http.Response> removeFriendApi(String theirUid) async {
  final token = await loadJwt();
  final res = await http.post(
    Uri.parse('$serverUri/api/v1/remove-friend'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode(<String, String>{'theirUid': theirUid}),
  );

  return res;
}
