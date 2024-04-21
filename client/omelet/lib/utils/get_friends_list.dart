import 'dart:convert';

import 'package:http/http.dart';

import 'package:omelet/api/get/get_user_public_info_api.dart';
import 'package:omelet/api/get/get_friend_list_api.dart';

Future<List<Map<String, dynamic>>> getFriendsList() async {
  try {
    final getFriendsListApi = await getFriendListApi();

    var jsonResponse = jsonDecode(getFriendsListApi.body);
    print('[get_friends_list] 使用者好友列表：${jsonResponse['data']}');
    List jsonFriendsData = jsonResponse['data'];
    List<String> stringList =
        jsonFriendsData.map((item) => item.toString()).toList();

    if (jsonFriendsData.isNotEmpty) {
      List<Future<Response>> responseFutures =
          stringList.map((i) => getUserPublicInfoApi(i)).toList();
      List<Map<String, dynamic>> resultList =
          await convertIterableToList(responseFutures, stringList);
      print('[get_friends_list] 好友公開資訊：$resultList');
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

Future<List<Map<String, dynamic>>> convertIterableToList(
    Iterable<Future<Response>> iterable, List<String> uidList) async {
  List<Map<String, dynamic>> resultList = [];
  // 使用索引来遍历 uidList
  await Future.forEach(iterable, (Future<Response> future) async {
    Response response = await future;
    Map<String, dynamic> responseData =
        response.body.isNotEmpty ? jsonDecode(response.body) : {};

    // 将 uid 添加到 responseData['data'] 中
    responseData['data']['uid'] = uidList[resultList.length];

    resultList.add(responseData);
  });
  return resultList;
}
