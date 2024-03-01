import 'dart:convert';

import 'package:http/http.dart' as http;
import './../../utils/load_jwt.dart';

import './../../utils/server_uri.dart';

Future<http.Response> updatePfp() async {
  final token = await loadJwt();
  final res = await http.post(Uri.parse('$serverUri/api/v1/update-pfp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, String>{'pfpData': 'haha'}));

  return res;
}
