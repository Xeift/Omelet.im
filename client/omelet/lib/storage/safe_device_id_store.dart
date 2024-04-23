import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:omelet/utils/load_local_info.dart';

class SafeDeviceIdStore {
  final storage = const FlutterSecureStorage();

  Future<void> updateOthersDeviceIds(
      String theirUid, List<String> deviceIdList) async {
    final ourUid = await loadCurrentActiveAccount();
    await storage.write(
        key: '${ourUid}_deviceId_$theirUid', value: jsonEncode(deviceIdList));
  }

  Future<void> removeOthersDeviceIds(String theirUid) async {
    final ourUid = await loadCurrentActiveAccount();
    await storage.delete(key: '${ourUid}_deviceId_$theirUid');
  }

  Future<List<String>> getOthersDeviceIds(String theirUid) async {
    final ourUid = await loadCurrentActiveAccount();
    final othersDeviceIds =
        await storage.read(key: '${ourUid}_deviceId_$theirUid');
    if (othersDeviceIds == null) {
      return [];
    }
    return List<String>.from(jsonDecode(othersDeviceIds));
  }
}
