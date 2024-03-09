// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:test_im_v4/api/get/get_unread_msg_api.dart';

import 'package:test_im_v4/message/safe_msg_store.dart';

Future<void> checkUnreadMsg() async {
  // 取得未讀訊息
  final getUnreadMsgAPIRes = await getUnreadMsgAPI();
  final List<dynamic> unreadMsgs = jsonDecode(getUnreadMsgAPIRes.body)['data'];
  print('[main.dart] 未讀訊息👉 $unreadMsgs');

  // 儲存未讀訊息
  if (unreadMsgs.isNotEmpty) {
    final safeMsgStore = SafeMsgStore();
    await safeMsgStore.sortAndstoreUnreadMsg(unreadMsgs);
  }
}
