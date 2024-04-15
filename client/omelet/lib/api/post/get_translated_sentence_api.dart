// 翻譯 API

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:omelet/utils/load_local_info.dart';

Future<http.Response> getTranslatedSentenceApi(String originalText) async {
  final token = await loadJwt();
  final res = await http.post(
    Uri.parse('$serverUri/api/v1/get-translated-sentence'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode(<String, String>{'msg': originalText}),
  );

  return res;
}
