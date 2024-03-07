// ignore_for_file: avoid_print

import './../message/safe_msg_store.dart';

Future<void> onGetUserListBtnPressed(Function updateHintMsg) async {
  final safeMsgStore = SafeMsgStore();
  final chatList = await safeMsgStore.getChatList();
  print('[on_read]Chat list: $chatList');
}
