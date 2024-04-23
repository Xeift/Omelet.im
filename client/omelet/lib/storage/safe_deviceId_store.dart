// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:omelet/utils/load_local_info.dart';

class SafeConfigStore {
  final storage = const FlutterSecureStorage();

  Future<void> updateOthersDeviceIds(String uid, String deviceIdList) async {}
  Future<void> removeOthersDeviceIds(String uid) async {}
  Future<void> getOthersDeviceIds(String uid) async {}
}
