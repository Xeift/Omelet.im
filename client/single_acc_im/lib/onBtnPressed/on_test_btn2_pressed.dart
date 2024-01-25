// ignore_for_file: avoid_print

import './../signal_protocol/safe_session_store.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

Future<void> onTestBtn2Pressed(Function updateHintMsg) async {
  final safeSessionStore = SafeSessionStore();
  const remoteAddress = SignalProtocolAddress('492312533160431617', 1);
  final sess = await safeSessionStore.loadSession(remoteAddress);
  print(sess.serialize());
}
