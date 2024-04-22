// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:convert';

import 'package:image_picker/image_picker.dart';

import 'package:omelet/api/post/upload_img_api.dart';
import 'package:omelet/pages/message/chat_room_page.dart';
import 'package:omelet/signal_protocol/encrypt_msg.dart';
import 'package:omelet/utils/generate_random_filename.dart';
import 'package:omelet/utils/load_local_info.dart';
import 'package:omelet/storage/safe_msg_store.dart';

Future<void> onSelectImageBtnPressed(String theirUid) async {
  final ourUid = await loadCurrentActiveAccount();
  final currentTimestamp = DateTime.now().millisecondsSinceEpoch.toString();

  // 選擇圖片
  final picker = ImagePicker();
  var image =
      await picker.pickImage(source: ImageSource.gallery, imageQuality: 60);
  print('[on_select_imgage_btn_prssed.dart] 選完照片');

  if (image != null) {
    print('[on_select_imgage_btn_prssed.dart] image不為空:$image');
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
    print('[on_select_imgage_btn_prssed.dart]儲存完照片');
    // 加密圖片
    final encryptedImg = await encryptMsg(theirUid, imgBytes);
    print('[on_select_imgage_btn_prssed.dart] encryptedImg: $encryptedImg');

    final ourEncryptedImg = encryptedImg['ourMsgInfo'];
    final theirEncryptedImg = encryptedImg['theirMsgInfo'];
    print(
        '[on_select_imgage_btn_prssed.dart] ourEncryptedImg:$ourEncryptedImg');
    print(
        '[on_select_imgage_btn_prssed.dart] theirEncryptedImg:$theirEncryptedImg');

    if (ourEncryptedImg != null) {
      for (var deviceId in ourEncryptedImg.keys) {
        // 將加密過的圖片上傳至伺服器
        print('test');
        var filename = generateRandomFileName(); // 產生隨機檔名
        var res = await uploadImgApi(deviceId, ourEncryptedImg[deviceId],
            ourUid, ourUid, theirUid, imgBytes, filename);

        print(
            '[on_send_msg_btn_pressed.dart] ${await res.stream.bytesToString()}');
      }
    } else {
      print(
          '[on_select_imgage_btn_prssed.dart]ourEncryptedImg空了:$ourEncryptedImg');
    }

    if (theirEncryptedImg != null) {
      for (var deviceId in theirEncryptedImg.keys) {
        // 將加密過的圖片上傳至伺服器
        var filename = generateRandomFileName(); // 產生隨機檔名
        var res = await uploadImgApi(deviceId, theirEncryptedImg[deviceId],
            theirUid, ourUid, theirUid, imgBytes, filename);

        print(
            '[on_send_msg_btn_pressed.dart] ${await res.stream.bytesToString()}');
      }
    }
    ChatRoomPageState.currenInstance()?.reloadData();
  } else {
    print('No image selected.');
  }
}
