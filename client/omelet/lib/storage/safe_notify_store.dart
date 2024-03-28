// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SafeNotifyStore {
  final storage = const FlutterSecureStorage();

  Future<void> writeNotification(Map<String, dynamic> value) async {
    print('[safe_notify_store] 已儲存');
    final key = 'notify_${value['timestamp']}';
    final data = jsonEncode(value);
    await storage.write(key: key, value: data);
  }

  Future<Map<String, dynamic>> readNotification(int timestamp) async {
    final key = 'notify_$timestamp';
    final result = await storage.read(key: key);
    return result != null ? jsonDecode(result) : null;
  }

  Future<void> deleteNotification(int timestamp) async {
    final key = 'notify_$timestamp';
    await storage.delete(key: key);
  }

  Future<List> readAllNotifications() async {
    final allValues = await storage.readAll();
    return allValues.entries
        .where((element) => element.key.startsWith('notify_'))
        .map((e) => jsonDecode(e.value))
        .toList();
        //TODO:檢視在notification_page
  }
}




