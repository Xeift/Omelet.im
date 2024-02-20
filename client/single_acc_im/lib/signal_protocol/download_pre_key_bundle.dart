// ignore_for_file: avoid_print

import 'dart:math';
import 'dart:convert';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import './../api/get/download_pre_key_bundle_api.dart';
import './../api/get/get_available_opk_index_api.dart';

Future<Map<String, dynamic>> downloadPreKeyBundle(String remoteUid) async {
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

  final ourPreKeyBundle = multiDevicesPreKeyBundle['data']['ourPreKeyBundle'];
  final theirPreKeyBundle =
      multiDevicesPreKeyBundle['data']['theirPreKeyBundle'];

  Future<(IdentityKey, ECPublicKey, Uint8List, ECPublicKey, int, int)>
      preKeyBundleTypeConverter(String deviceId,
          Map<String, dynamic> singlePreKeyBundle, final character) async {
    final ipkPub = IdentityKey.fromBytes(
        Uint8List.fromList(
            jsonDecode(singlePreKeyBundle['ipkPub']).cast<int>().toList()),
        0);
    final spkPub = Curve.decodePoint(
        Uint8List.fromList(
            jsonDecode(singlePreKeyBundle['spkPub']).cast<int>().toList()),
        0);
    final spkSig = Uint8List.fromList(
        jsonDecode(singlePreKeyBundle['spkSig']).cast<int>().toList());
    final opkPub = Curve.decodePoint(
        Uint8List.fromList(
            (jsonDecode(singlePreKeyBundle['opkPub'])).cast<int>().toList()),
        0);
    final spkId = int.parse(singlePreKeyBundle['spkId']);
    final opkId = int.parse(
        jsonDecode(multiDevicesOpkIndexesRandom)[character][deviceId]);

    return (ipkPub, spkPub, spkSig, opkPub, spkId, opkId);
  }

  final ourPreKeyBundleConverted = ourPreKeyBundle.map((key, value) => MapEntry(
      key, preKeyBundleTypeConverter(key, value, 'ourPreKeyIndexRandom')));
  final theirPreKeyBundleConverted = theirPreKeyBundle.map((key, value) =>
      MapEntry(key,
          preKeyBundleTypeConverter(key, value, 'theirPreKeyIndexRandom')));
  print(ourPreKeyBundleConverted);
  return {
    'ourPreKeyBundleConverted': ourPreKeyBundleConverted,
    'theirPreKeyBundleConverted': theirPreKeyBundleConverted
  };
}

T randomChoice<T>(List<T> list) {
  var random = Random();
  return list[random.nextInt(list.length)];
}
