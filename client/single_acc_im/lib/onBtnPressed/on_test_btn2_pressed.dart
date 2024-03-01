// ignore_for_file: avoid_print
import './../api/post/update_pfp.dart';

Future<void> onTestBtn2Pressed(Function updateHintMsg) async {
  final res = await updatePfp();
  print(res.body);
}
