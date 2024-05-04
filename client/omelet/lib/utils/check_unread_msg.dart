// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:omelet/api/get/get_unread_msg_api.dart';
import 'package:omelet/storage/safe_msg_store.dart';

Future<void> checkUnreadMsg() async {
  // 取得未讀訊息
  final getUnreadMsgAPIRes = await getUnreadMsgApi();
  final List<dynamic> unreadMsgs = jsonDecode(getUnreadMsgAPIRes.body)['data'];
  print('[check_unread_msg] 未讀訊息：${jsonDecode(getUnreadMsgAPIRes.body)}');

  // 儲存未讀訊息
  if (unreadMsgs.isNotEmpty) {
    final safeMsgStore = SafeMsgStore();
    await safeMsgStore.sortAndstoreUnreadMsgs(unreadMsgs);
  }
}
