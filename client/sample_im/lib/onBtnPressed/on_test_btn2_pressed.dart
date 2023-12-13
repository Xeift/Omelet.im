// ignore_for_file: avoid_print
import './../signal_protocol/signal_protocol.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> onTestBtnPressed2(Function updateHintMsg) async {
  print('[on_test_btn_pressed2.dart] test');
  const storge = FlutterSecureStorage();
  await updateHintMsg((await storge.readAll()).toString());
}
