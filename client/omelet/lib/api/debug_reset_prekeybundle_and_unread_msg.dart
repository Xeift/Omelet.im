// debug 用，可刪除MongoDB 中所有 pre key bundle 和 unread msg

import 'package:http/http.dart' as http;

import 'package:omelet/utils/load_local_info.dart';

Future<http.Response> debugResetPrekeyBundleAndUnreadMsgApi() async {
  final token = await loadJwt();
  final res = await http.post(
    Uri.parse('$serverUri/api/v1/debug-reset-prekeybundle-and-unread-msg'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    },
  );

  return res;
}
