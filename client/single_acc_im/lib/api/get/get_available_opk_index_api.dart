import 'package:http/http.dart' as http;

import './../../utils/server_uri.dart';
import './../../utils/load_jwt.dart';

Future<http.Response> getAvailableOpkIndexApi(String remoteUid) async {
  final token = await loadJwt();

  final res = await http.get(
      Uri.parse('$serverUri/api/v1/get-available-opk-index?uid=$remoteUid'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      });

  return res;
}
