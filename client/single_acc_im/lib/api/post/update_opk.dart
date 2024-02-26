import 'dart:convert';

import 'package:http/http.dart' as http;
import './../../utils/load_jwt_and_ipk_pub.dart';

import './../../utils/server_uri.dart';

Future<http.Response> updateOpk(opkPub) async {
  final (token, ipkPub) = await loadJwtAndIpkPub();
  final res = await http.post(Uri.parse('$serverUri/api/v1/update-opk'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, String>{
        'ipkPub': ipkPub,
        'opkPub': opkPub,
      }));

  return res;
}
