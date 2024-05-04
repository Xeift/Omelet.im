// 更新 one-time pre key 用

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:omelet/utils/server_uri.dart';
import 'package:omelet/storage/safe_account_store.dart';
import 'package:omelet/storage/safe_device_id_store.dart';

Future<http.Response> updateOpkApi(opkPub) async {
  final token = await loadJwt();
  final safeDeviceIdStore = SafeDeviceIdStore();
  final deviceId = await safeDeviceIdStore.getLocalDeviceId();

  final res = await http.post(Uri.parse('$serverUri/api/v1/update-opk'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, String>{
        'deviceId': deviceId,
        'opkPub': opkPub,
      }));

  return res;
}
