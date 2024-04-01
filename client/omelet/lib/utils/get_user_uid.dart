// ignore_for_file: avoid_print

import 'package:omelet/utils/load_local_info.dart';

String ourUid = '';

Future<void> getUserUid() async {
  ourUid = await loadCurrentActiveAccount();
  print('抓取使用者uid{$ourUid}');
}
