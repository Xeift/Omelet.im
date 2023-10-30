import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> onRemoveAllBtnPressed(Function updateHintMsg) async {
  print('[on_remove_all_btn_pressed.dart] remove all');
  const storage = FlutterSecureStorage();
  await storage.deleteAll();
  updateHintMsg('已刪除所有 secure storage 中之資料：）');
}
