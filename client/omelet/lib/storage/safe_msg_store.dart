import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:omelet/api/get/get_user_public_info_api.dart';
import 'package:omelet/utils/server_uri.dart';
import 'package:omelet/signal_protocol/decrypt_msg.dart';
import 'package:omelet/storage/safe_account_store.dart';

class SafeMsgStore {
  final storage = const FlutterSecureStorage();
  final ourUid = loadCurrentActiveAccount();

  Future<String> uidToKey(String remoteUid, int index) async {
    final ourUid = await loadCurrentActiveAccount();
    return '${ourUid}_msg_${remoteUid}_$index';
  }

  Future<void> writeMsg(String remoteUid, Map<String, dynamic> msg) async {
    final msgJson = jsonEncode(msg);
    String key = await uidToKey(remoteUid, await getMsgCount(remoteUid) + 1);
    await storage.write(key: key, value: msgJson);
  }

  Future<Map<String, dynamic>> readMsg(String remoteUid, int index) async {
    String key = await uidToKey(remoteUid, index);
    final ourCurrentUid = await loadCurrentActiveAccount();
    return jsonDecode(
        (await storage.read(key: '${ourCurrentUid}_$key')).toString());
  }

  Future<void> deleteMsg(String remoteUid, int index) async {
    String key = await uidToKey(remoteUid, index);

    await storage.delete(key: key);
  }

  Future<int> getMsgCount(String remoteUid) async {
    Map<String, String> allData = await storage.readAll();
    final ourCurrentUid = await loadCurrentActiveAccount();
    List<String> filteredKeys = allData.keys
        .where((key) => key.startsWith('${ourCurrentUid}_msg_${remoteUid}_'))
        .toList();

    return filteredKeys.length;
  }

  Future<List<Map<String, dynamic>>> readLast100Msg(String remoteUid) async {
    // 讀取所有訊息
    Map<String, String> allData = await storage.readAll();
    // 篩選與特定使用者的訊息
    final ourCurrentUid = await loadCurrentActiveAccount();
    List<String> filteredKeys = allData.keys
        .where((key) => key.startsWith('${ourCurrentUid}_msg_${remoteUid}_'))
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
    final ourCurrentUid = await loadCurrentActiveAccount();
    List<String> filteredKeys = allData.keys
        .where((key) => key.startsWith('${ourCurrentUid}_msg_${remoteUid}_'))
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
        final imgUrl = "$serverUri/img/${unreadMsg['content']}";
        var response = await http.get(Uri.parse(imgUrl));
        unreadMsg['content'] = response.body;
      }

      // 解密訊息
      final decryptedMsg = await decryptMsg(
        unreadMsg['isPreKeySignalMessage'],
        unreadMsg['sender'],
        int.parse(unreadMsg['senderDeviceId']),
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

  Future<(String, String)> storeReceivedMsg(
      Map<String, dynamic> receivedMsg) async {
    // 若為圖片，則根據檔名下載加密過的圖片
    if (receivedMsg['type'] == 'image') {
      final imgUrl = "$serverUri/img/${receivedMsg['content']}";
      var response = await http.get(Uri.parse(imgUrl));
      receivedMsg['content'] = response.body;
    }

    // 解密訊息
    final decryptedMsg = await decryptMsg(
      receivedMsg['isPreKeySignalMessage'],
      receivedMsg['sender'],
      int.parse(receivedMsg['senderDeviceId']),
      receivedMsg['content'],
    );

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

    final senderName = receivedMsg['senderUsername'].toString();
    if (receivedMsg['type'] == 'image') {
      return (senderName, '[圖片]');
    } else {
      return (senderName, decryptedMsg);
    }
  }

  Future<Map<String, dynamic>> getChatList() async {
    Map<String, String> allData = await storage.readAll();
    Map<String, dynamic> lastMsgWithEachUser = {};
    final ourCurrentUid = await loadCurrentActiveAccount();
    for (var entry in allData.entries) {
      List<String> keyParts = entry.key.split('_');
      if (keyParts.length != 4 || keyParts[1] != 'msg') continue;
      if (keyParts[0] != ourCurrentUid) continue;

      String remoteUid = keyParts[2];
      int index = int.parse(keyParts[3]);

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
