import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<String> loadUid() async {
  const storage = FlutterSecureStorage();
  final uid = (await storage.read(key: 'uid')).toString();

  return uid;
}
