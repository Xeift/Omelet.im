import 'package:http/http.dart' as http;

import 'package:omelet/utils/load_local_info.dart';

Future<http.Response> getSelfSpkStatusApi() async {
  final (token, ipkPub) = await loadJwtAndIpkPub();

  final res = await http.get(
      Uri.parse('$serverUri/api/v1/get-self-spk-status?ipkPub=$ipkPub'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      });

  return res;
}
