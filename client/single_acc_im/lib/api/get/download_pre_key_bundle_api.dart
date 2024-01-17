import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../utils/server_uri.dart';
import './get_available_opk_index.dart';

T randomChoice<T>(List<T> list) {
  var random = Random();
  return list[random.nextInt(list.length)];
}

Future<http.Response> downloadPreKeyBundleAPI(String uid) async {
  const storage = FlutterSecureStorage();
  final token = await storage.read(key: 'token');
  final avaibleOpkIndex =
      randomChoice(jsonDecode((await getAvailableOpkIndex(uid)).body)['data']);

  print(avaibleOpkIndex);
  print(avaibleOpkIndex.runtimeType);
  print('--------------------------------');

  final res = await http.get(
      Uri.parse('$serverUri/api/v1/download-pre-key-bundle?uid=$uid'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      });
  return res;
}
