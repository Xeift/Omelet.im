// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:omelet/api/get/get_friend_list_api.dart';

import 'package:omelet/message/safe_msg_store.dart';

Future<void> getfriendslist() async {
  // 取得未讀訊息
  final getFriendsListApi = await getFriendListApi();
  final List<dynamic> friendsList = jsonDecode(getFriendsListApi.body)['data'];
  print('[main.dart] 使用者好友👉 $friendsList');

  // 儲存未讀訊息
  if (friendsList.isNotEmpty) {
    final safeMsgStore = SafeMsgStore();
    print(friendsList);
  }else{
    print(friendsList);
  }
}
