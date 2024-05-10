import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:omelet/storage/safe_account_store.dart';

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
    //檢查用戶是否啟用翻譯功能
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

  Future<void> setTranslationDestLang(String uid, String destLang) async {
    final ourUid = await loadCurrentActiveAccount();

    await storage.write(
        key: '${ourUid}_config_translationDestLang', value: destLang);
  }

  Future<String> getTranslationDestLang(String uid) async {
    final ourUid = await loadCurrentActiveAccount();

    return (await storage.read(key: '${ourUid}_config_translationDestLang'))
        .toString();
  }
}
