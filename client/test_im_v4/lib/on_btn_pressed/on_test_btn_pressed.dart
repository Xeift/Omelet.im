// ignore_for_file: avoid_print

import 'package:test_im_v4/message/safe_msg_store.dart';

Future<void> onTestBtnPressed(Function updateHintMsg) async {
  final safeMsgStore = SafeMsgStore();
  final msgs = await safeMsgStore.getChatList();

  updateHintMsg('[on_test_btn_pressed.dart] chat list👉: $msgs');
  print('[on_test_btn_pressed.dart] chat list👉: $msgs');
}
