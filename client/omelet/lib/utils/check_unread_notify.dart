import 'dart:convert';
import 'package:omelet/api/get/get_friend_request_api.dart';
import 'package:omelet/storage/safe_notify_store.dart';

Future<void> checkUnreadNotify() async {
  // 取得未讀通知
  final getFriendRequestApiRes = await getFriendRequestApi();
  final List<dynamic> unreadNotify =
      jsonDecode(getFriendRequestApiRes.body)['data'];

  // 儲存未讀通知
  if (unreadNotify.isNotEmpty) {
    final safeNotifyStore = SafeNotifyStore();
    for (var notify in unreadNotify) {
      await safeNotifyStore.writeNotification(notify);
    }
  }
}
