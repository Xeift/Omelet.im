import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

const storage = FlutterSecureStorage();

Future<bool> isJwtExsist() async {
  return (await storage.read(key: 'token')) != null;
}

Future<bool> isJwtValid(String serverUri, Function updateHintMsg) async {
  final token = await storage.read(key: 'token');
  final res = await http.post(
    Uri.parse('$serverUri/api/v1/check-jwt-status'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    },
  );
  // final resBody = jsonDecode(res.body);
  if (res.statusCode == 200) {
    print('jwt 有效✅');
    return true;
  } else {
    print('jwt 無效❌');
    return false;
  }
}
