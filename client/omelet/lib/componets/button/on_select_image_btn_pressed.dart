// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:convert';

import 'package:image_picker/image_picker.dart';

import 'package:omelet/pages/message/chat_room_page.dart';
import 'package:omelet/pages/message/multi_screen/multi_chat_room.dart';
import 'package:omelet/storage/safe_msg_store.dart';
import 'package:omelet/storage/safe_account_store.dart';
import 'package:omelet/signal_protocol/encrypt_msg.dart';

Future<void> onSelectImageBtnPressed(String theirUid) async {
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
    await encryptMsg(theirUid, imgBytes, 'image');

    ChatRoomPageState.currenInstance()?.reloadData();
    MultiChatRoomPageState.currenInstanceInMultiChat()?.reloadDataInMulti();
  } else {
    print('No image selected.');
  }
}
