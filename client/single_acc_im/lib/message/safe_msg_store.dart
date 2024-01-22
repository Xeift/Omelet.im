// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import './../signal_protocol/decrypt_msg.dart';

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

  Future<void> sortAndstoreUnreadMsg(List<dynamic> unreadMsgs) async {
    unreadMsgs.sort((a, b) {
      int timestampA = int.parse(a['timestamp']);
      int timestampB = int.parse(b['timestamp']);
      return timestampA.compareTo(timestampB);
    });

    for (var unreadMsg in unreadMsgs) {
      final decryptedMsg = await decryptMsg(int.parse(unreadMsg['sender']),
          unreadMsg['content'], unreadMsg['spkId'], unreadMsg['opkId']);
      print('$decryptedMsg\n');
      await writeMsg(unreadMsg['sender'], {
        'timestamp': unreadMsg['timestamp'],
        'type': unreadMsg['type'],
        'receiver': 'self',
        'sender': unreadMsg['sender'],
        'content': decryptedMsg
      });
    }
  }
}
