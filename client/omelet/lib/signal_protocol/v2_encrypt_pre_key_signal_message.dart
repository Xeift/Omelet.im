import 'dart:convert';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import 'package:omelet/api/get/v2_download_pre_key_bundle_api.dart';
import 'package:omelet/signal_protocol/safe_spk_store.dart';
import 'package:omelet/signal_protocol/safe_opk_store.dart';
import 'package:omelet/signal_protocol/safe_session_store.dart';
import 'package:omelet/signal_protocol/safe_identity_store.dart';

Future<void> v2EncryptPreKeySignalMessage(String theirUid, String theirDeviceId,
    SignalProtocolAddress receiverAddress) async {
  final ipkStore = SafeIdentityKeyStore();
  final spkStore = SafeSpkStore();
  final opkStore = SafeOpkStore();
  final sessionStore = SafeSessionStore();

  // TODO: 下載單一 PreKeyBundle
  final preKeyBundle = await v2DownloadPreKeyBundleApi(theirUid, theirDeviceId);
  print('❌❌❌❌❌');
  print(preKeyBundle.body);
  print('❌❌❌❌❌');
}
