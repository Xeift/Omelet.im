import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:test_im_v4/utils/load_local_info.dart';

Future<http.Response> updateSpk(spkPub, spkSig) async {
  final (token, ipkPub) = await loadJwtAndIpkPub();
  final res = await http.post(Uri.parse('$serverUri/api/v1/update-spk'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, String>{
        'ipkPub': ipkPub,
        'spkPub': spkPub,
        'spkSig': spkSig,
      }));

  return res;
}
