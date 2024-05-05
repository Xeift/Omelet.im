// 用於下載 PreKeyBundle

import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

import 'package:omelet/utils/server_uri.dart';
import 'package:omelet/api/get/get_available_opk_index_api.dart';
import 'package:omelet/storage/safe_account_store.dart';

Future<http.Response> downloadPreKeyBundleApi(
    String theirUid, String theirDeviceId) async {
  final token = await loadJwt();
  final opkIds = jsonDecode(
          (await getAvailableOpkIndexApi(theirUid, theirDeviceId)).body)['data']
      ['opkIds'];

  final opkId = randomChoice(opkIds);

  final res = await http.get(
      Uri.parse(
          '$serverUri/api/v1/download-pre-key-bundle?theirUid=$theirUid&theirDeviceId=$theirDeviceId&opkId=$opkId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      });

  return res;
}

T randomChoice<T>(List<T> list) {
  var random = Random();
  return list[random.nextInt(list.length)];
}
