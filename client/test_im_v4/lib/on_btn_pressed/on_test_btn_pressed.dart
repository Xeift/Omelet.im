// ignore_for_file: avoid_print

import 'package:test_im_v4/message/safe_msg_store.dart';

Future<void> onTestBtnPressed(Function updateHintMsg) async {
  final safeMsgStore = SafeMsgStore();
  final msgs = await safeMsgStore.readLast100Msg('552415467919118336');

  updateHintMsg('Last 100 msg👉: $msgs');
  print('Last 100 msg👉: $msgs');
}
