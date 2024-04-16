// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:omelet/utils/load_local_info.dart';

class SafeConfigStore {
  final storage = const FlutterSecureStorage();

  Future<void> debugShowAllActiveTranslateUid() async {
    final ourUid = await loadCurrentActiveAccount();
    final cfg =
        await storage.read(key: '${ourUid}_config_translationAciveTarget');
    List<String> cfgList = [];

    if (cfg != null) {
      cfgList = List<String>.from(jsonDecode(cfg));
    }

    print(
        '[safe_config_store debugShowAllActiveTranslateUid] cfgList👉 $cfgList $ourUid');
  }

  Future<void> enableTranslation(String uid) async {
    final ourUid = await loadCurrentActiveAccount();
    final cfg =
        await storage.read(key: '${ourUid}_config_translationAciveTarget');
    List<String> cfgList = [];

    if (cfg != null) {
      cfgList = List<String>.from(jsonDecode(cfg));
      print('not empty!😎');
    }

    if (!cfgList.contains(uid)) {
      cfgList.add(uid);
      await storage.write(
          key: '${ourUid}_config_translationAciveTarget',
          value: jsonEncode(cfgList));
    }

    final cfg2 =
        await storage.read(key: '${ourUid}_config_translationAciveTarget');
    print('[safe_config_store enableTranslation] cfg2👉 $cfg2');
  }
}
