import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:omelet/utils/load_local_info.dart';

Future<http.Response> replyFriendRequestApi(
    String theirUid, bool isAgree) async {
  final res = await http.post(
    Uri.parse('$serverUri/api/v1/reply-friend-request'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
        <String, String>{'theirUid': theirUid, 'isAgree': isAgree.toString()}),
  );

  return res;
}
