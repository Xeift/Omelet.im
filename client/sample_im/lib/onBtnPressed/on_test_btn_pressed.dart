// ignore_for_file: avoid_print

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> onTestBtnPressed(Function updateHintMsg) async {
  print('[on_test_btn_pressed.dart] test');
  updateHintMsg('testt');
}
