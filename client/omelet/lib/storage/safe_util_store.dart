import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SafeUtilStore {
  final storage =const FlutterSecureStorage();

  // Writing data to storage
  Future<void> writeIsSend(String uid, bool isSended) async {
    final List<Map<String, dynamic>> myList = await readIsSendeList();
    
    // 檢查是否已存在相同的uid
    bool alreadyExists = myList.any((element) => element['uid'] == uid && element['isSended'] == isSended);
    
    if (!alreadyExists) {
      // 只有當不存在相同的uid時才將資料加入列表
      myList.add({'uid': uid, 'isSended': isSended});
      await _saveListToSecureStorage(myList);
      print('[safe_util_store]已將好友列入messageList中 uid $uid, isSended $isSended');
    } else {
      print('[safe_util_store]該uid已存在於列表中: $uid');
    }
  }


  // Reading data from storage
  Future<List<Map<String, dynamic>>> readIsSendeList() async {
    final String? storedList = await storage.read(key: 'myList');
    if (storedList != null) {
      return List<Map<String, dynamic>>.from(json.decode(storedList));
    } else {
      return [];
    }
  }

  // Saving list to secure storage
  Future<void> _saveListToSecureStorage(List<Map<String, dynamic>> myList) async {
    final String jsonList = json.encode(myList);
    await storage.write(key: 'myList', value: jsonList);
  }
}