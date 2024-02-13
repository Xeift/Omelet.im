import 'package:http/http.dart' as http;

import './../../utils/server_uri.dart';
import './../../utils/load_jwt_and_ipk_pub.dart';

Future<http.Response> getSelfOpkStatus() async {
  final (token, ipkPub) = await loadJwtAndIpkPub();

  final res = await http.get(
      Uri.parse('$serverUri/api/v1/get-self-opk-status?ipkPub=$ipkPub'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      });

  return res;
}
