import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<String> loadJwt() async {
  const storage = FlutterSecureStorage();
  final token = (await storage.read(key: 'token')).toString();

  return token;
}
