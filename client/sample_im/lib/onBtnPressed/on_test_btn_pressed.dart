// ignore_for_file: avoid_print
import './../signal_protocol/signal_protocol.dart';

Future<void> onTestBtnPressed(Function updateHintMsg) async {
  print('[on_test_btn_pressed.dart] test');
  await install();
}
