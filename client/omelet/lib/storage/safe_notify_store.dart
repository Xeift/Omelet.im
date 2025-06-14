import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:omelet/storage/safe_account_store.dart';

class SafeNotifyStore {
  final storage = const FlutterSecureStorage();

  Future<void> writeNotification(Map<String, dynamic> value) async {
    final key = 'notify_${value['timestamp']}';
    final data = jsonEncode(value);
    final ourUid = await loadCurrentActiveAccount();
    await storage.write(key: '${ourUid}_$key', value: data);
  }

  Future<Map<String, dynamic>> readNotification(int timestamp) async {
    final ourCurrentUid = await loadCurrentActiveAccount();
    final key = '${ourCurrentUid}_notify_$timestamp';
    final result = await storage.read(key: key);
    return result != null ? jsonDecode(result) : null;
  }

  Future<void> deleteNotification(int timestamp) async {
    final ourUid = await loadCurrentActiveAccount();
    final key = '${ourUid}_notify_$timestamp';
    await storage.delete(key: key);
  }

  Future<List> readAllNotifications() async {
    final allValues = await storage.readAll();
    final ourCurrentUid = await loadCurrentActiveAccount();
    return allValues.entries
        .where((element) => element.key.startsWith('${ourCurrentUid}_notify_'))
        .map((e) => jsonDecode(e.value))
        .toList();
  }
}
