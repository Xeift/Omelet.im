// ignore_for_file: avoid_print
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> onTestBtnPressed2(Function updateHintMsg) async {
  print('[on_test_btn_pressed2.dart] test');
  const storage = FlutterSecureStorage();
  await updateHintMsg(
      '${(await storage.readAll()).keys.toString()}\n${(await storage.readAll()).toString()}');
  print(
      '${(await storage.readAll()).keys.toString()}\n${(await storage.readAll()).toString()}');
}
