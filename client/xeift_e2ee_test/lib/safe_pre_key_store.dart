import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class SafePreKeyStore implements PreKeyStore {
  final FlutterSecureStorage storage;

  SafePreKeyStore(this.storage);

  static const String preKey = 'preKey';

  @override
  Future<bool> containsPreKey(int preKeyId) async {
    // Read the map from storage
    final value = await storage.read(key: preKey);
    if (value == null) {
      return false;
    }
    final map = jsonDecode(value) as Map;
    // Get the value from the map by preKeyId
    final record = map[preKeyId.toString()];
    return record != null;
  }

  @override
  Future<PreKeyRecord> loadPreKey(int preKeyId) async {
    // Read the map from storage
    final value = await storage.read(key: preKey);
    if (value == null) {
      throw InvalidKeyIdException('No such prekey record: $preKeyId');
    }
    final map = jsonDecode(value) as Map;
    // Get the value from the map by preKeyId
    final record = map[preKeyId.toString()];
    if (record == null) {
      throw InvalidKeyIdException('No such prekey record: $preKeyId');
    }
    // Convert the value to Uint8List and return PreKeyRecord object
    return PreKeyRecord.fromBuffer(Uint8List.fromList(base64Decode(record)));
  }

  @override
  Future<void> removePreKey(int preKeyId) async {
    // Read the map from storage
    final value = await storage.read(key: preKey);
    if (value == null) {
      return;
    }
    final map = jsonDecode(value) as Map;
    // Remove the key-value pair from the map by preKeyId
    map.remove(preKeyId.toString());
    // Convert the updated map to a JSON string and write it to storage
    await storage.write(key: preKey, value: jsonEncode(map));
  }

  @override
  Future<void> storePreKey(int preKeyId, PreKeyRecord record) async {
    // Read the existing map from storage
    final value = await storage.read(key: preKey);
    // If the map is null, create an empty one
    final map = value == null ? {} : jsonDecode(value) as Map;
    // Add the preKeyId and record.serialize() as a key-value pair to the map
    map[preKeyId.toString()] = base64Encode(record.serialize());
    // Convert the map to a JSON string and write it to storage
    await storage.write(key: preKey, value: jsonEncode(map));
  }
}
