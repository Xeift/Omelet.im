// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:omelet/utils/load_local_info.dart';

class SafeConfigStore {
  final storage = const FlutterSecureStorage();

  Future<List<String>> debugShowAllActiveTranslateUid() async {
    final ourUid = await loadCurrentActiveAccount();
    final cfg =
        await storage.read(key: '${ourUid}_config_translationAciveTarget');
    List<String> cfgList = [];

    if (cfg != null) {
      cfgList = List<String>.from(jsonDecode(cfg));
    }

    return cfgList;
  }

  Future<void> enableTranslation(String uid) async {
    final ourUid = await loadCurrentActiveAccount();
    final cfg =
        await storage.read(key: '${ourUid}_config_translationAciveTarget');
    List<String> cfgList = [];

    if (cfg != null) {
      cfgList = List<String>.from(jsonDecode(cfg));
    }

    if (!cfgList.contains(uid)) {
      cfgList.add(uid);
      await storage.write(
          key: '${ourUid}_config_translationAciveTarget',
          value: jsonEncode(cfgList));
    }
  }

  Future<void> disableTranslation(String uid) async {
    final ourUid = await loadCurrentActiveAccount();
    final cfg =
        await storage.read(key: '${ourUid}_config_translationAciveTarget');
    List<String> cfgList = [];

    if (cfg != null) {
      cfgList = List<String>.from(jsonDecode(cfg));
    }

    if (cfgList.contains(uid)) {
      cfgList.remove(uid);
      await storage.write(
          key: '${ourUid}_config_translationAciveTarget',
          value: jsonEncode(cfgList));
    }
  }

  Future<bool> isTranslateActive(String uid) async {
    final ourUid = await loadCurrentActiveAccount();
    final cfg =
        await storage.read(key: '${ourUid}_config_translationAciveTarget');
    List<String> cfgList = [];

    if (cfg != null) {
      cfgList = List<String>.from(jsonDecode(cfg));
    }

    if (cfgList.contains(uid)) {
      return true;
    }

    return false;
  }
}
