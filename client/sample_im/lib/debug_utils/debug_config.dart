import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<Map<String, dynamic>> readDebugConfig() async {
  const storage = FlutterSecureStorage();
  final res = jsonDecode((await storage.read(key: 'debug_config')).toString());
  return res;
}

Future<void> writeDebugConfig(
    String apiBaseUrl, String username, String password) async {
  const storage = FlutterSecureStorage();
  await storage.write(
      key: 'debug_config',
      value: jsonEncode({
        'apiBaseUrl': apiBaseUrl,
        'username': username,
        'password': password
      }));
}
