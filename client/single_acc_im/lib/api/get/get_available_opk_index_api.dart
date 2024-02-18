import 'package:http/http.dart' as http;

import './../../utils/server_uri.dart';
import './../../utils/load_jwt_and_ipk_pub.dart';

Future<http.Response> getAvailableOpkIndexApi(String remoteUid) async {
  final (token, ipkPub) = await loadJwtAndIpkPub();

  final res = await http.get(
      Uri.parse(
          '$serverUri/api/v1/get-available-opk-index?uid=$remoteUid&ipkPub=$ipkPub'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      });

  return res;
}
