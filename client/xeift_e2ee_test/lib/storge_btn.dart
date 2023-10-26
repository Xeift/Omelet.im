// ignore_for_file: avoid_print

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> onWriteBtnPressed(String key, String value) async {
  print('write');
  print('$key $value');
  const storage = FlutterSecureStorage();
  await storage.write(key: key, value: value);
}

Future<void> onRemoveBtnPressed(String key) async {
  print('remove');
  print(key);
  const storage = FlutterSecureStorage();
  await storage.delete(key: key);
}

Future<void> onRemoveAllBtnPressed() async {
  print('remove all');
  const storage = FlutterSecureStorage();
  await storage.deleteAll();
}

Future<void> onReadAllBtnPressed() async {
  const storage = FlutterSecureStorage();
  final res = await storage.readAll();
  print(res);
}
