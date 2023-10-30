import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SafeMsgStore {
  final storage = const FlutterSecureStorage();

  String uidToKey(String friendUid, int index) {
    return 'msg_${friendUid}_$index';
  }

  Future<void> writeMsg(String friendUid, Map<String, dynamic> msg) async {
    final msgJson = jsonEncode(msg);
    String key = uidToKey(friendUid, await getMsgCount(friendUid) + 1);
    await storage.write(key: key, value: msgJson);
  }

  Future<Map<String, dynamic>> readMsg(String friendUid, int index) async {
    String key = uidToKey(friendUid, index);
    return jsonDecode((await storage.read(key: key)).toString());
  }

  Future<void> deleteMsg(String friendUid, int index) async {
    String key = uidToKey(friendUid, index);
    await storage.delete(key: key);
  }

  Future<int> getMsgCount(String friendUid) async {
    Map<String, String> allData = await storage.readAll();
    List<String> filteredKeys = allData.keys
        .where((key) => key.startsWith('msg_${friendUid}_'))
        .toList();
    return filteredKeys.length;
  }
}
