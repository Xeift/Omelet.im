// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:convert';

import 'package:image_picker/image_picker.dart';

import 'package:omelet/api/post/upload_img_api.dart';
import 'package:omelet/pages/message/chat_room_page.dart';
import 'package:omelet/pages/message/multi_screen/multi_chat_room.dart';
import 'package:omelet/utils/generate_random_filename.dart';
import 'package:omelet/utils/load_local_info.dart';
import 'package:omelet/storage/safe_msg_store.dart';
import 'package:omelet/signal_protocol/v2_encrypt_msg.dart';

Future<void> v2OnSelectImageBtnPressed(String theirUid) async {
  final ourUid = await loadCurrentActiveAccount();
  final currentTimestamp = DateTime.now().millisecondsSinceEpoch.toString();

  // 選擇圖片
  final picker = ImagePicker();
  var image =
      await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

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
    await v2EncryptMsg(theirUid, imgBytes, 'image');

    ChatRoomPageState.currenInstance()?.reloadData();
    MultiChatRoomPageState.currenInstanceInMultiChat()?.reloadDataInMulti();
  } else {
    print('No image selected.');
  }
}
