// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:omelet/api/get/get_user_public_info_api.dart';

import 'package:omelet/utils/load_local_info.dart';
import 'package:omelet/signal_protocol/decrypt_msg.dart';
import 'package:http/http.dart' as http;

class SafeMsgStore {
  final storage = const FlutterSecureStorage();
  final ourUid = loadUid();

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

  Future<List<Map<String, dynamic>>> readLast100Msg(String remoteUid) async {
    // 讀取所有訊息
    Map<String, String> allData = await storage.readAll();
    // 篩選與特定使用者的訊息
    List<String> filteredKeys = allData.keys
        .where((key) => key.startsWith('msg_${remoteUid}_'))
        .toList();
    filteredKeys.sort((a, b) =>
        int.parse(b.split('_').last).compareTo(int.parse(a.split('_').last)));
    // 取出最新的 100 則訊息
    List<Map<String, dynamic>> messages = [];
    for (String key in filteredKeys.take(100)) {
      messages.add(jsonDecode(allData[key]!));
    }

    return messages;
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

  Future<void> sortAndstoreUnreadMsgs(List<dynamic> unreadMsgs) async {
    // 先對 timestamp 進行升序排序，舊訊息在前新訊息在後
    // 這樣訊息的 index 才會是正確的順序
    unreadMsgs.sort((a, b) {
      int timestampA = int.parse(a['timestamp']);
      int timestampB = int.parse(b['timestamp']);

      return timestampA.compareTo(timestampB);
    });

    for (var unreadMsg in unreadMsgs) {
      // 若為圖片，則根據檔名下載加密過的圖片
      if (unreadMsg['type'] == 'image') {
        print('😎img $unreadMsg');
        final imgUrl = "$serverUri/img/${unreadMsg['content']}";
        var response = await http.get(Uri.parse(imgUrl));
        unreadMsg['content'] = response.body;
      }

      // 解密訊息
      final decryptedMsg = await decryptMsg(
        unreadMsg['isPreKeySignalMessage'],
        int.parse(unreadMsg['sender']),
        unreadMsg['content'],
      );

      // 處理從自己其他裝置發送訊息的情況
      final String senderKey;
      // 稍後寫入時的 key 應為接收者的 id
      // 如果傳送訊息的是自己，寫入的 key 應為接收者
      if (unreadMsg['sender'] == ourUid) {
        senderKey = unreadMsg['receiver'];
      } else {
        senderKey = unreadMsg['sender'];
      }

      await writeMsg(senderKey, {
        'timestamp': unreadMsg['timestamp'],
        'type': unreadMsg['type'],
        'sender': unreadMsg['sender'],
        'receiver': unreadMsg['receiver'],
        'content': decryptedMsg
      });
    }
  }

  Future<void> storeReceivedMsg(Map<String, dynamic> receivedMsg) async {
    // 若為圖片，則根據檔名下載加密過的圖片
    if (receivedMsg['type'] == 'image') {
      print('😎img $receivedMsg');
      final imgUrl = "$serverUri/img/${receivedMsg['content']}";
      var response = await http.get(Uri.parse(imgUrl));
      receivedMsg['content'] = response.body;
    }

    // 解密訊息
    final decryptedMsg = await decryptMsg(
      receivedMsg['isPreKeySignalMessage'],
      int.parse(receivedMsg['sender']),
      receivedMsg['content'],
    );

    // // 若為圖片，則將解密後的圖片儲存至 App Directory
    // if (receivedMsg['type'] == 'image') {
    //   List<int> bytes = jsonDecode(decryptedMsg).cast<int>();
    //   final directory = await getApplicationDocumentsDirectory();
    //   File file = File('${directory.path}/output.png');
    //   print('已儲存到 ${directory.path}/output.png');
    //   file.writeAsBytesSync(bytes);
    // }

    // 處理從自己其他裝置發送訊息的情況
    final String senderKey;
    // 稍後寫入時的 key 應為接收者的 id
    // 如果傳送訊息的是自己，寫入的 key 應為接收者
    if (receivedMsg['sender'] == ourUid) {
      senderKey = receivedMsg['receiver'];
    } else {
      senderKey = receivedMsg['sender'];
    }

    await writeMsg(senderKey, {
      'timestamp': receivedMsg['timestamp'],
      'type': receivedMsg['type'],
      'sender': receivedMsg['sender'],
      'receiver': receivedMsg['receiver'],
      'content': decryptedMsg
    });
  }

  Future<Map<String, dynamic>> getChatList() async {
    Map<String, String> allData = await storage.readAll();
    Map<String, dynamic> lastMsgWithEachUser = {};

    for (var entry in allData.entries) {
      List<String> keyParts = entry.key.split('_');
      if (keyParts.length != 3 || keyParts[0] != 'msg') continue;

      String remoteUid = keyParts[1];
      int index = int.parse(keyParts[2]);

      if (!lastMsgWithEachUser.containsKey(remoteUid) ||
          lastMsgWithEachUser[remoteUid]['index'] < index) {
        var remoteUserInfoRes = await getUserPublicInfoApi(remoteUid);
        var remoteUserInfo = jsonDecode(remoteUserInfoRes.body)['data'];
        lastMsgWithEachUser[remoteUid] = {
          'remoteUserInfo': remoteUserInfo,
          'index': index,
          'message': jsonDecode(entry.value),
        };
      }
    }

    return lastMsgWithEachUser;
  }
}
