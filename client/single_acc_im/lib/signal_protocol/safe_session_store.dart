// ignore_for_file: implementation_imports, avoid_print

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:libsignal_protocol_dart/src/signal_protocol_address.dart';
import 'package:libsignal_protocol_dart/src/state/session_record.dart';
import 'package:libsignal_protocol_dart/src/state/session_store.dart';

class SafeSessionStore implements SessionStore {
  final storage = const FlutterSecureStorage();

  @override
  Future<bool> containsSession(SignalProtocolAddress address) async {
    return await storage.read(key: address.toString()) != null;
  }

  @override
  Future<void> deleteAllSessions(String name) async {
    final allKeys = await storage.readAll();
    allKeys.keys
        .where((k) => k.startsWith(name))
        .forEach((k) async => await storage.delete(key: k));
  }

  @override
  Future<void> deleteSession(SignalProtocolAddress address) async {
    await storage.delete(key: address.toString());
  }

  @override
  Future<List<int>> getSubDeviceSessions(String name) async {
    final deviceIds = <int>[];
    final allKeys = await storage.readAll();
    allKeys.keys
        .where((k) => k.startsWith(name) && !k.endsWith(':1'))
        .forEach((k) => deviceIds.add(int.parse(k.split(':')[1])));
    return deviceIds;
  }

  @override
  Future<SessionRecord> loadSession(SignalProtocolAddress address) async {
    try {
      final sessionData = await storage.read(key: address.toString());
      print('[safe_session_store.dart] sessionData: $sessionData');
      if (sessionData != null) {
        return SessionRecord.fromSerialized(
            Uint8List.fromList(jsonDecode(sessionData).cast<int>().toList()));
      } else {
        return SessionRecord();
      }
    } on Exception catch (e) {
      throw AssertionError(e);
    }
  }

  @override
  Future<void> storeSession(
      SignalProtocolAddress address, SessionRecord record) async {
    await storage.write(
        key: address.toString(), value: jsonEncode(record.serialize()));
  }
}
