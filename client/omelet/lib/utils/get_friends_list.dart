import 'dart:convert';
import 'package:flutter/semantics.dart';
import 'package:http/http.dart';
import 'package:omelet/api/get/get_user_public_info_api.dart';
import 'package:omelet/utils/get_user_uid.dart';
import 'package:omelet/api/get/get_friend_list_api.dart';
import 'package:omelet/utils/get_user_uid.dart';
import 'package:omelet/utils/load_local_info.dart';

Future<List<Map<String, dynamic>>> getFriendsList() async {
  try {
    final getFriendsListApi = await getFriendListApi();
  
    var jsonResponse = jsonDecode(getFriendsListApi.body);
    print('[main.dart] 使用者好友👉 ${jsonResponse['data']}');
    List jsonFriendsData = jsonResponse['data'];
    List<String> stringList = jsonFriendsData.map((item) => item.toString()).toList();
    print('${stringList.runtimeType}');
    print('[get_friends_list.dart]jsonFriendsData:$stringList');

    if (jsonFriendsData.isNotEmpty) {
      // 使用 map() 函数将每个 UID 传递给 getUserPublicInfoApi，并生成一个包含 Future<Response> 的列表
      List<Future<Response>> responseFutures = stringList.map((i) => getUserPublicInfoApi(i)).toList();

      // 调用 convertIterableToList 函数，将 Future<Response> 转换为 List<Map<String, dynamic>>
      List<Map<String, dynamic>> resultList = await convertIterableToList(responseFutures,stringList);
      print(resultList);
      return resultList;
    } else {
      print('[get_friends_list.dart]list is empty');
      return [];
    }
  } catch (e) {
    print('Error fetching friends list: $e');
    return [];
  }
}

Future<List<Map<String, dynamic>>> convertIterableToList(Iterable<Future<Response>> iterable, List<String> uidList) async {
  List<Map<String, dynamic>> resultList = [];
  // 使用索引来遍历 uidList
  await Future.forEach(iterable, (Future<Response> future) async {
    Response response = await future;
    Map<String, dynamic> responseData = response.body.isNotEmpty ? jsonDecode(response.body) : {};

    // 将 uid 添加到 responseData['data'] 中
    responseData['data']['uid'] = uidList[resultList.length];

    resultList.add(responseData);
  });
  return resultList;
}
