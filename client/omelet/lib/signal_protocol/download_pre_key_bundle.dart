// ignore_for_file: avoid_print

import 'dart:math';
import 'dart:convert';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import 'package:omelet/api/get/download_pre_key_bundle_api.dart';
import 'package:omelet/api/get/get_available_opk_index_api.dart';

Future<Map<String, dynamic>> downloadPreKeyBundle(String remoteUid) async {
  // 取得可用的 opk index
  final multiDevicesOpkIndexesRes = await getAvailableOpkIndexApi(remoteUid);
  final multiDevicesOpkIndexesResBody =
      jsonDecode(multiDevicesOpkIndexesRes.body);

  // opk 分為我方其他裝置的 opk 及 Bob 所有裝置的 opk
  final ourPreKeyIndex =
      multiDevicesOpkIndexesResBody['data']['ourPreKeyIndex'];
  final theirPreKeyIndex =
      multiDevicesOpkIndexesResBody['data']['theirPreKeyIndex'];

  // 隨機選擇要使用的 opk
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

  // 根據 opk index 下載我方其他所有裝置和 Bob 所有裝置的 PreKeyBundle
  final res =
      await downloadPreKeyBundleApi(remoteUid, multiDevicesOpkIndexesRandom);

  final multiDevicesPreKeyBundle = jsonDecode(res.body);

  final ourPreKeyBundle = multiDevicesPreKeyBundle['data']['ourPreKeyBundle'];
  final theirPreKeyBundle =
      multiDevicesPreKeyBundle['data']['theirPreKeyBundle'];

  // 將下載的 PreKeyBundle 形態轉換為函式庫可使用的形態
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

  // 批次轉換形態
  final ourPreKeyBundleConverted = ourPreKeyBundle.map((key, value) => MapEntry(
      key, preKeyBundleTypeConverter(key, value, 'ourPreKeyIndexRandom')));
  final theirPreKeyBundleConverted = theirPreKeyBundle.map((key, value) =>
      MapEntry(key,
          preKeyBundleTypeConverter(key, value, 'theirPreKeyIndexRandom')));

  return {
    'ourPreKeyBundleConverted': ourPreKeyBundleConverted,
    'theirPreKeyBundleConverted': theirPreKeyBundleConverted
  };
}

T randomChoice<T>(List<T> list) {
  var random = Random();
  return list[random.nextInt(list.length)];
}
