import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './../utils/server_uri.dart';

const storage = FlutterSecureStorage();

Future<bool> isJwtExsist() async {
  return (await storage.read(key: 'token')) != null;
}

Future<bool> isJwtValid() async {
  final token = await storage.read(key: 'token');
  final res = await http.post(
    Uri.parse('$serverUri/api/v1/check-jwt-status'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    },
  );
  if (res.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
