import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SafeMsgStore {
  final storage = const FlutterSecureStorage();

  String uidToKey(String remoteUid, int index) {
    return 'msg_${remoteUid}_$index';
  }

  Future<void> writeMsg(String remoteUid, Map<String, dynamic> msg) async {
    final msgJson = jsonEncode(msg);
    String key = uidToKey(remoteUid, await getMsgCount(remoteUid) + 1);
    await storage.write(key: key, value: msgJson);
  }

  Future<Map<String, dynamic>> readMsg(String remoteUid, int index) async {
    String key = uidToKey(remoteUid, index);
    return jsonDecode((await storage.read(key: key)).toString());
  }

  Future<void> deleteMsg(String remoteUid, int index) async {
    String key = uidToKey(remoteUid, index);
    await storage.delete(key: key);
  }

  Future<int> getMsgCount(String remoteUid) async {
    Map<String, String> allData = await storage.readAll();
    List<String> filteredKeys = allData.keys
        .where((key) => key.startsWith('msg_${remoteUid}_'))
        .toList();
    return filteredKeys.length;
  }

  Future<List<String>> readAllMsg(String remoteUid) async {
    Map<String, String> allData = await storage.readAll();
    List<String> filteredKeys = allData.keys
        .where((key) => key.startsWith('msg_${remoteUid}_'))
        .toList();
    List<String> messages = [];
    for (String key in filteredKeys) {
      messages.add(allData[key]!);
    }
    return messages;
  }
}
