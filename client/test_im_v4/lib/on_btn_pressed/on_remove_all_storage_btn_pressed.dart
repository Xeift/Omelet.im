import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> onRemoveAllBtnPressed(Function updateHintMsg) async {
  const storage = FlutterSecureStorage();
  await storage.deleteAll();
  updateHintMsg(
      '已刪除所有 secure storage 中之資料\n目前所有資料為👉${await storage.readAll()}');
}
