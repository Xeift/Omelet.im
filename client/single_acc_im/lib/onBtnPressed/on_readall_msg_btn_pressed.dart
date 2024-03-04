// ignore_for_file: avoid_print

import './../message/safe_msg_store.dart';

Future<void> onGetUserListBtnPressed(Function updateHintMsg) async {
  final safeMsgStore = SafeMsgStore();
  final allMsgs = await safeMsgStore.readLast100Msg('492312533160431617');
  for (var allMsg in allMsgs) {
    print(allMsg);
  }
}
