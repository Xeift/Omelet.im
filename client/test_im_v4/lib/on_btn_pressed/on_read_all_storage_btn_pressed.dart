// ignore_for_file: avoid_print
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> onReadAllStorageBtnPressed(Function updateHintMsg) async {
  const storage = FlutterSecureStorage();
  final key = (await storage.readAll()).keys.toString();
  final allData = (await storage.readAll()).toString();
  await updateHintMsg('$key\n$allData');
  print('$key\n$allData');
}
