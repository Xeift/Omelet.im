import 'package:http/http.dart' as http;

import './../../utils/server_uri.dart';
import './../../utils/load_jwt.dart';

Future<http.Response> downloadPreKeyBundleAPI(
    String remoteUid, String multiDevicesOpkIndexesRandom) async {
  final token = await loadJwt();

  final res = await http.get(
      Uri.parse(
          '$serverUri/api/v1/download-pre-key-bundle?uid=$remoteUid&multiDevicesOpkIndexesRandom=$multiDevicesOpkIndexesRandom'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      });

  return res;
}
