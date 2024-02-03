import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import './../../utils/server_uri.dart';

Future<http.Response> getUnreadMsgAPI() async {
  const storage = FlutterSecureStorage();
  final token = await storage.read(key: 'token');

  final res = await http.get(Uri.parse('$serverUri/api/v1/get-unread-msg'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      });

  return res;
}
