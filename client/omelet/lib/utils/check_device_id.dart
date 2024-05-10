import 'dart:convert';

import 'package:omelet/api/get/get_device_ids_api.dart';

import 'package:omelet/storage/safe_device_id_store.dart';

Future<void> checkDeviceId() async {
  final res = await getDeviceIdsApi();
  final deviceIds = jsonDecode(res.body)['data'];
  final ourOtherDeviceIds = deviceIds['ourOtherDeviceIds'];
  List<String> ourOtherDeviceIdsString = ourOtherDeviceIds
      .map((deviceId) => deviceId.toString())
      .toList()
      .cast<String>();
  final friendDeviceIds = deviceIds['friendDeviceIds'];

  final safeDeviceIdStore = SafeDeviceIdStore();
  await safeDeviceIdStore.updateOurDeviceIds(ourOtherDeviceIdsString);

  for (var entry in friendDeviceIds.entries) {
    List<String> friendDeviceIdsString = entry.value
        .map((deviceId) => deviceId.toString())
        .toList()
        .cast<String>();
    await safeDeviceIdStore.updateTheirDeviceIds(
        entry.key, friendDeviceIdsString);
  }
}
