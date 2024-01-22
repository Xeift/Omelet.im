import 'dart:convert';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import './../signal_protocol/download_pre_key_bundle.dart';
import './../signal_protocol/safe_identity_store.dart';
import './../signal_protocol/safe_spk_store.dart';
import './../signal_protocol/safe_opk_store.dart';
import './../signal_protocol/safe_session_store.dart';
import '../signal_protocol/decrypt_msg.dart';

Future<void> onDecryptMsg(
    String receiverId, String msgContent, Function updateHintMsg) async {
  await decryptMsg(492312533160431617, '[arr]', 0, 0);
}
