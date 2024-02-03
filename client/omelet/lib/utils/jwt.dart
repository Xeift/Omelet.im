import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

Future<bool> isJwtExsist() async {
  return (await storage.read(key: 'token')) != null;
}
