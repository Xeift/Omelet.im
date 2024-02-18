// ignore_for_file: avoid_print

import 'dart:math';
import 'dart:convert';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import './../api/get/download_pre_key_bundle_api.dart';
import './../api/get/get_available_opk_index_api.dart';

Future<(IdentityKey, ECPublicKey, Uint8List, ECPublicKey, int, String)>
    downloadPreKeyBundle(String remoteUid) async {
  final multiDevicesOpkIndexesRes = await getAvailableOpkIndexApi(remoteUid);
  final multiDevicesOpkIndexesResBody =
      jsonDecode(multiDevicesOpkIndexesRes.body);

  print('多裝置 opkId 內容👉$multiDevicesOpkIndexesResBody');

  final ourPreKeyIndex =
      multiDevicesOpkIndexesResBody['data']['ourPreKeyIndex'];
  final theirPreKeyIndex =
      multiDevicesOpkIndexesResBody['data']['theirPreKeyIndex'];

  print(
      '[download_pre_key_bundle.dart] 多裝置 ourPreKeyIndex 內容👉$ourPreKeyIndex');
  print(
      '[download_pre_key_bundle.dart] 多裝置 theirPreKeyIndex 內容👉$theirPreKeyIndex');

  // TODO: make downloadPreKeyBundleAPI support multi devices

  final ourPreKeyIndexRandom = {};
  final theirPreKeyIndexRandom = {};

  ourPreKeyIndex.forEach((key, value) {
    ourPreKeyIndexRandom[key] = randomChoice(value);
  });

  theirPreKeyIndex.forEach((key, value) {
    theirPreKeyIndexRandom[key] = randomChoice(value);
  });

  final multiDevicesOpkIndexesRandom = jsonEncode({
    'ourPreKeyIndexRandom': ourPreKeyIndexRandom,
    'theirPreKeyIndexRandom': theirPreKeyIndexRandom
  });

  print(
      '[download_pre_key_bundle.dart] multiDevicesOpkIndexesRandom random ver:  $multiDevicesOpkIndexesRandom');

  final res =
      await downloadPreKeyBundleAPI(remoteUid, multiDevicesOpkIndexesRandom);

  final multiDevicesPreKeyBundle = jsonDecode(res.body);
  print(
      '[download_pre_key_bundle.dart] pkb 內容👉 ${multiDevicesPreKeyBundle['data']}');

  // TODO: deal with multi device pre key bundle type convert

  final ipkPub = IdentityKey.fromBytes(
      Uint8List.fromList(
          jsonDecode(multiDevicesPreKeyBundle['ipkPub']).cast<int>().toList()),
      0);
  final spkPub = Curve.decodePoint(
      Uint8List.fromList(
          jsonDecode(multiDevicesPreKeyBundle['spkPub']).cast<int>().toList()),
      0);
  final spkSig = Uint8List.fromList(
      jsonDecode(multiDevicesPreKeyBundle['spkSig']).cast<int>().toList());
  final opkPub = Curve.decodePoint(
      Uint8List.fromList((jsonDecode(multiDevicesPreKeyBundle['opkPub']))
          .cast<int>()
          .toList()),
      0);
  final spkId = multiDevicesPreKeyBundle['spkId'];

  return (
    ipkPub,
    spkPub,
    spkSig,
    opkPub,
    int.parse(spkId),
    multiDevicesOpkIndexesRandom
  );
}

T randomChoice<T>(List<T> list) {
  var random = Random();
  return list[random.nextInt(list.length)];
}
