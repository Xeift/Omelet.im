// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

import './../signal_protocol/decrypt_msg.dart';
import './../utils/load_uid.dart';

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

  Future<List<String>> readLast100Msg(String remoteUid) async {
    Map<String, String> allData = await storage.readAll();
    List<String> filteredKeys = allData.keys
        .where((key) => key.startsWith('msg_${remoteUid}_'))
        .toList();
    filteredKeys.sort((a, b) =>
        int.parse(b.split('_').last).compareTo(int.parse(a.split('_').last)));
    List<String> messages = [];
    for (String key in filteredKeys.take(100)) {
      messages.add(allData[key]!);
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

  Future<void> sortAndstoreUnreadMsg(List<dynamic> unreadMsgs) async {
    unreadMsgs.sort((a, b) {
      int timestampA = int.parse(a['timestamp']);
      int timestampB = int.parse(b['timestamp']);

      return timestampA.compareTo(timestampB);
    });

    for (var unreadMsg in unreadMsgs) {
      final decryptedMsg = await decryptMsg(unreadMsg['isPreKeySignalMessage'],
          int.parse(unreadMsg['sender']), unreadMsg['content']);

      // handle msg sent from our other device
      final String senderKey;
      if (unreadMsg['sender'] == ourUid) {
        senderKey = unreadMsg['receiver'];
      } else {
        senderKey = unreadMsg['sender'];
      }

      await writeMsg(senderKey, {
        'timestamp': unreadMsg['timestamp'],
        'type': unreadMsg['type'],
        'receiver': unreadMsg['receiver'],
        'sender': unreadMsg['sender'],
        'content': decryptedMsg
      });
    }
  }

  Future<void> storeReceivedMsg(Map<String, dynamic> receivedMsg) async {
    final decryptedMsg = await decryptMsg(receivedMsg['isPreKeySignalMessage'],
        int.parse(receivedMsg['sender']), receivedMsg['content']);

    // handle msg sent from our other device
    final String senderKey;
    if (receivedMsg['sender'] == ourUid) {
      senderKey = receivedMsg['receiver'];
    } else {
      senderKey = receivedMsg['sender'];
    }

    if (receivedMsg['type'] == 'image') {
      // TODO:
      print('😎img');
      Directory? downloadsDirectory = await getDownloadsDirectory();
      var file = File('${downloadsDirectory?.path}/your_file.png');
      final imageBytes =
          Uint8List.fromList(jsonDecode(decryptedMsg).cast<int>());
      await file.writeAsBytes(imageBytes);
    }

    await writeMsg(senderKey, {
      'timestamp': receivedMsg['timestamp'],
      'type': receivedMsg['type'],
      'receiver': receivedMsg['receiver'],
      'sender': receivedMsg['sender'],
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
        lastMsgWithEachUser[remoteUid] = {
          'index': index,
          'message': jsonDecode(entry.value),
        };
      }
    }

    return lastMsgWithEachUser;
  }
}
