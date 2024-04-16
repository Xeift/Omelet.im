// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:omelet/utils/load_local_info.dart';

class SafeConfigStore {
  final storage = const FlutterSecureStorage();

  Future<void> debugShowAllActiveTranslateUid() async {
    final ourUid = await loadCurrentActiveAccount();
    final cfg = await storage.read(key: '${ourUid}_config');
    List<String> cfgList = [];

    if (cfg != null) {
      cfgList = jsonDecode(cfg);
      print('not empty!');
    }

    print('[safe_config_store] cfg👉 $cfgList');
  }

  Future<void> enableTranslation(String uid) async {
    final ourUid = await loadCurrentActiveAccount();
    final cfg = await storage.read(key: '${ourUid}_config');
    List<String> cfgList = [];

    if (cfg != null) {
      cfgList = jsonDecode(cfg);
      print('not empty!');
    }

    print('[safe_config_store] cfg👉 $cfgList');
    print('[safe_config_store] cfg type👉 ${cfgList.runtimeType}');
  }
}
