// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:omelet/pages/message/chat_room_page.dart';
import 'package:omelet/pages/message/multi_screen/multi_chat_room.dart';
import 'package:omelet/utils/return_msg_to_server.dart';
import 'package:omelet/signal_protocol/v2_encrypt_msg.dart';
import 'package:omelet/pages/login_signup/loading_page.dart' show socket;
import 'package:omelet/utils/load_local_info.dart';
import 'package:omelet/storage/safe_msg_store.dart';

Future<void> v2OnSendMsgBtnPressed(String theirUid, String msgContent) async {
  print('[v2_on_send_msg_btn_pressed] 訊息原始內容: $msgContent');
  final ourUid = await loadCurrentActiveAccount();
  final currentTimestamp = DateTime.now().millisecondsSinceEpoch.toString();

  // 將發送的訊息儲存到本地
  final safeMsgStore = SafeMsgStore();
  await safeMsgStore.writeMsg(theirUid, {
    'timestamp': currentTimestamp,
    'type': 'text',
    'sender': ourUid,
    'receiver': theirUid,
    'content': msgContent,
  });

  // 加密訊息
  await v2EncryptMsg(theirUid, msgContent, 'text');

  //發送訊息時，顯示一則新訊息在聊天室
  ChatRoomPageState.currenInstance()?.reloadData();
  MultiChatRoomPageState.currenInstanceInMultiChat()?.reloadDataInMulti();
}
