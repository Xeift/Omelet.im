// ignore_for_file: avoid_print

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
    final preKeys = jsonDecode((await storage.read(key: preKey)).toString());
    if (preKeys == null) {
      throw InvalidKeyIdException('no prekey found');
    }

    final singlePreKey = preKeys[preKeyId.toString()];

    return singlePreKey != null;
  }

  @override
  Future<PreKeyRecord> loadPreKey(int preKeyId) async {
    final preKeys = jsonDecode((await storage.read(key: preKey)).toString());
    if (preKeys == null) {
      throw InvalidKeyIdException('no prekey found');
    }

    final singlePreKey = preKeys[preKeyId.toString()];
    if (singlePreKey == null) {
      throw InvalidKeyIdException('No such prekey record: $preKeyId');
    }

    return PreKeyRecord.fromBuffer(Uint8List.fromList( jsonDecode(singlePreKey).cast<int>().toList() ));
  }

  @override
  Future<void> removePreKey(int preKeyId) async {
    var preKeys = jsonDecode((await storage.read(key: preKey)).toString());
    if (preKeys == null) {
      throw InvalidKeyIdException('no prekey found');
    }

    preKeys.remove(preKeyId.toString());

    await storage.write(
      key: preKey,
      value: jsonEncode(preKeys)
    );
  }

  @override
  Future<void> storePreKey(int preKeyId, PreKeyRecord record) async { // TODO:
    print(record); // <PreKeyRecord> Instance of 'PreKeyRecord'
    print(record
        .serialize()); // <Uint8List> [8, 109, 18, 33, 5, 67, 164, 221, 199, 239, 218, 92, 200, 22, 68, 106, 53, 31, 203, 199, 66, 27, 246, 237, 60, 53, 24, 204, 146, 97, 242, 25, 163, 143, 38, 131, 118, 26, 32, 72, 142, 39, 4, 40, 168, 227, 114, 192, 167, 113, 202, 196, 112, 9, 28, 2, 157, 220, 226, 23, 10, 203, 191, 130, 175, 150, 148, 12, 90, 206, 67]
    print(record.serialize().runtimeType);

    const storage = FlutterSecureStorage();

    final preKeys = jsonDecode((await storage.read(key: preKey)).toString());
    print(preKeys);
    // Map<string, dynamic> = preKeys

    final encodedPreKeyId = preKeyId.toString(); // <int> .to_String() <String>
    // print(encodedPreKeyId.runtimeType);

    final encodedPreKeyRecord =
        jsonEncode(record.serialize()); // <Uint8List> jsonEncode() <String>
    // print(encodedPreKeyRecord.runtimeType);

    //----------------------------------------------------------------

    final decodedPreKeyId = int.parse(encodedPreKeyId);
    // print(decodedPreKeyId.runtimeType);

    var decodedPreKeyRecordTemp = jsonDecode(encodedPreKeyRecord);
    final decodedPreKeyRecord =
        Uint8List.fromList(decodedPreKeyRecordTemp.cast<int>().toList());
    // print(decodedPreKeyRecord.runtimeType);
  }
}
