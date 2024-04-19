// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:omelet/api/get/get_friend_request_api.dart';
import 'package:omelet/storage/safe_notify_store.dart';

Future<void> checkUnreadNotify() async {
  // 取得未讀通知
  final getFriendRequestApiRes = await getFriendRequestApi();
  final List<dynamic> unreadNotify =
      jsonDecode(getFriendRequestApiRes.body)['data'];
  print('[check_unread_notify] 未讀通知：$unreadNotify');

  // 儲存未讀通知
  if (unreadNotify.isNotEmpty) {
    print('not empty');
    final safeNotifyStore = SafeNotifyStore();
    for (var notify in unreadNotify) {
      print('notify is: $notify');
      await safeNotifyStore.writeNotification(notify);
    }
  }
}
