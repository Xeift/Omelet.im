import 'package:http/http.dart' as http;

import 'package:test_im_v4/utils/load_local_info.dart';

Future<http.Response> getUserPublicInfoAPI(uid) async {
  final token = await loadJwt();

  final res = await http.get(
      Uri.parse('$serverUri/api/v1/get-user-public-info?uid=$uid'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      });

  return res;
}
