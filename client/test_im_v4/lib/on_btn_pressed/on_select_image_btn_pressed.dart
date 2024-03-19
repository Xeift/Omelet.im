// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:image_picker/image_picker.dart';
import 'package:test_im_v4/message/safe_msg_store.dart';
import 'package:test_im_v4/api/post/upload_img_api.dart';
import 'package:test_im_v4/signal_protocol/encrypt_msg.dart';
import 'package:test_im_v4/utils/generate_random_filename.dart';
import 'package:test_im_v4/utils/return_msg_to_server.dart';
import 'package:test_im_v4/utils/init_socket.dart' show socket;

Future<void> onSelectImageBtnPressed(
    String theirUid, Function updateHintMsg) async {
  final picker = ImagePicker();
  var image = await picker.pickImage(source: ImageSource.gallery);
  const storage = FlutterSecureStorage();
  final ourUid = (await storage.read(key: 'uid')).toString();
  final currentTimestamp = DateTime.now().millisecondsSinceEpoch.toString();

  if (image != null) {
    var img = File(image.path.toString());
    var imgBytes = jsonEncode(await img.readAsBytes());

    // 加密圖片
    final encryptedImg = await encryptMsg(theirUid, imgBytes);
    final ourEncryptedImg = encryptedImg['ourEncryptedMsg'];
    final theirEncryptedImg = encryptedImg['theirEncryptedMsg'];

    print('ourEncryptedImg.keys ${ourEncryptedImg.keys}');

    if (!ourEncryptedImg.isEmpty) {
      for (var deviceId in ourEncryptedImg.keys) {
        var (cihertext, _, _, _) = ourEncryptedImg[deviceId];
        var filename = generateRandomFileName(); // 產生隨機檔名
        var res = await uploadImgApi(cihertext, theirUid, deviceId, filename);

        // TODO: 加密訊息

        print(
            '[on_send_msg_btn_pressed.dart] ${await res.stream.bytesToString()}');
      }
    }

    print('theirEncryptedImg.keys ${theirEncryptedImg.keys}');

    if (!theirEncryptedImg.isEmpty) {
      for (var deviceId in theirEncryptedImg.keys) {
        var (cihertext, _, _, _) = theirEncryptedImg[deviceId];
        var filename = generateRandomFileName();
        var res = await uploadImgApi(cihertext, theirUid, deviceId, filename);
        print(
            '[on_send_msg_btn_pressed.dart] ${await res.stream.bytesToString()}');
      }
    }
  } else {
    print('No image selected.');
  }
}
