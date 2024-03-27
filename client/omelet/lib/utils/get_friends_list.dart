// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/semantics.dart';
import 'package:omelet/api/get/get_user_public_info_api.dart';
import 'package:omelet/utils/get_user_uid.dart';
import 'package:omelet/api/get/get_friend_list_api.dart';
import 'package:omelet/utils/get_user_uid.dart';
import 'package:omelet/utils/load_local_info.dart';

Future<List<Map<String, dynamic>>> getFriendsList() async {
  List<Map<String, dynamic>> friends_info_list = [];
  try {
    final getFriendsListApi = await getFriendListApi();
  
   var jsonResponse = jsonDecode(getFriendsListApi.body);
    print('[main.dart] 使用者好友👉 ${jsonResponse['data']}');
    List jsonFriendsData = jsonResponse['data'];
    List<String> stringList = jsonFriendsData.map((item) => item.toString()).toList();
    print('${stringList.runtimeType}');
    print('[get_friends_list.dart]jsonFriendsData:${stringList}');

    if (jsonFriendsData.isNotEmpty) {


      return [];
    } else {
      print('[get_friedns_list.dart]list is empty');
      return [];
    }
  } catch (e) {
    // 捕獲可能的異常
    print('Error fetching friends list: $e');
    // 返回空列表或適當的錯誤處理
    return [];
  }
}
