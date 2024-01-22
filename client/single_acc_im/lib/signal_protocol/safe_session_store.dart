// ignore_for_file: implementation_imports

import 'dart:convert';
import 'dart:collection';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:libsignal_protocol_dart/src/signal_protocol_address.dart';
import 'package:libsignal_protocol_dart/src/state/session_record.dart';
import 'package:libsignal_protocol_dart/src/state/session_store.dart';

class SafeSessionStore implements SessionStore {
  final storage = const FlutterSecureStorage();

  SafeSessionStore();

  HashMap<SignalProtocolAddress, String> sessions =
      HashMap<SignalProtocolAddress, String>();

  @override
  Future<bool> containsSession(SignalProtocolAddress address) async =>
      sessions.containsKey(address);

  @override
  Future<void> deleteAllSessions(String name) async {
    for (final k in sessions.keys.toList()) {
      if (k.getName() == name) {
        sessions.remove(k);
      }
    }
  }

  @override
  Future<void> deleteSession(SignalProtocolAddress address) async {
    sessions.remove(address);
  }

  @override
  Future<List<int>> getSubDeviceSessions(String name) async {
    final deviceIds = <int>[];

    for (final key in sessions.keys) {
      if (key.getName() == name && key.getDeviceId() != 1) {
        deviceIds.add(key.getDeviceId());
      }
    }

    return deviceIds;
  }

  @override
  Future<SessionRecord> loadSession(SignalProtocolAddress address) async {
    try {
      if (await containsSession(address)) {
        return SessionRecord.fromSerialized(
            Uint8List.fromList(jsonDecode(sessions[address]!).cast<int>()));
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
    sessions[address] = jsonEncode(record.serialize().toList());
    await storage.write(key: address.toString(), value: sessions[address]);
  }
}
