// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:omelet/api/post/upload_img_api.dart';
import 'package:omelet/signal_protocol/encrypt_msg.dart';
import 'package:omelet/utils/generate_random_filename.dart';
import 'package:omelet/utils/load_local_info.dart';
import 'package:omelet/storage/safe_msg_store.dart';

Future<void> onSelectImageBtnPressed(
    String theirUid, Function updateHintMsg) async {
  final ourUid = await loadUid();
  final currentTimestamp = DateTime.now().millisecondsSinceEpoch.toString();

  // 選擇圖片
  final picker = ImagePicker();
  var image = await picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    var img = File(image.path.toString());
    var imgBytes = jsonEncode(await img.readAsBytes());

    // 將發送的訊息儲存到本地
    final safeMsgStore = SafeMsgStore();
    await safeMsgStore.writeMsg(theirUid, {
      'timestamp': currentTimestamp,
      'type': 'image',
      'sender': ourUid,
      'receiver': theirUid,
      'content': imgBytes,
    });

    // 加密圖片
    final encryptedImg = await encryptMsg(theirUid, imgBytes);
    final ourEncryptedImg = encryptedImg['ourEncryptedMsg'];
    final theirEncryptedImg = encryptedImg['theirEncryptedMsg'];

    if (!ourEncryptedImg.isEmpty) {
      for (var deviceId in ourEncryptedImg.keys) {
        // 將加密過的圖片上傳至伺服器
        var filename = generateRandomFileName(); // 產生隨機檔名
        var res = await uploadImgApi(deviceId, ourEncryptedImg[deviceId],
            ourUid, ourUid, theirUid, imgBytes, filename);

        print(
            '[on_send_msg_btn_pressed.dart] ${await res.stream.bytesToString()}');
      }
    }

    if (!theirEncryptedImg.isEmpty) {
      for (var deviceId in theirEncryptedImg.keys) {
        // 將加密過的圖片上傳至伺服器
        var filename = generateRandomFileName(); // 產生隨機檔名
        var res = await uploadImgApi(deviceId, theirEncryptedImg[deviceId],
            theirUid, ourUid, theirUid, imgBytes, filename);

        print(
            '[on_send_msg_btn_pressed.dart] ${await res.stream.bytesToString()}');
      }
    }
  } else {
    print('No image selected.');
  }
}
