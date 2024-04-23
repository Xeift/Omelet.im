import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:omelet/utils/load_local_info.dart';

class SafeDeviceIdStore {
  final storage = const FlutterSecureStorage();

  Future<void> writeLocalDeviceId(String deviceId) async {
    final ourUid = await loadCurrentActiveAccount();
    await storage.write(key: '${ourUid}_localDeviceId', value: deviceId);
  }

  Future<String> getLocalDeviceId() async {
    final ourUid = await loadCurrentActiveAccount();
    final localDeviceId = await storage.read(key: '${ourUid}_localDeviceId');
    if (localDeviceId == null) {
      return '';
    } else {
      return localDeviceId;
    }
  }

  Future<void> updateTheirDeviceIds(
      String theirUid, List<String> deviceIdList) async {
    final ourUid = await loadCurrentActiveAccount();
    await storage.write(
        key: '${ourUid}_deviceId_$theirUid', value: jsonEncode(deviceIdList));
  }

  Future<void> removeTheirDeviceIds(String theirUid) async {
    final ourUid = await loadCurrentActiveAccount();
    await storage.delete(key: '${ourUid}_deviceId_$theirUid');
  }

  Future<List<String>> getOurDeviceIds(String theirUid) async {
    final ourUid = await loadCurrentActiveAccount();
    final ourDeviceIds = await storage.read(key: '${ourUid}_deviceId_$ourUid');
    if (ourDeviceIds == null) {
      return [];
    }
    return List<String>.from(jsonDecode(ourDeviceIds));
  }

  Future<List<String>> getTheirDeviceIds(String theirUid) async {
    final ourUid = await loadCurrentActiveAccount();
    final theirDeviceIds =
        await storage.read(key: '${ourUid}_deviceId_$theirUid');
    if (theirDeviceIds == null) {
      return [];
    }
    return List<String>.from(jsonDecode(theirDeviceIds));
  }
}
