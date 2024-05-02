// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:omelet/pages/message/chat_room_page.dart';
import 'package:omelet/pages/message/multi_screen/multi_chat_room.dart';
import 'package:omelet/utils/return_msg_to_server.dart';
import 'package:omelet/signal_protocol/encrypt_msg.dart';
import 'package:omelet/pages/login_signup/loading_page.dart' show socket;
import 'package:omelet/utils/load_local_info.dart';
import 'package:omelet/storage/safe_msg_store.dart';

Future<void> onSendMsgBtnPressed(String theirUid, String msgContent) async {
  print('[on_send_msg_btn_pressed 1] 訊息原始內容: $msgContent');
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
  final encryptedMsg =
      await encryptMsg(theirUid, '$msgContent $currentTimestamp'); // TODO: 計算延遲
  final ourEncryptedMsg = encryptedMsg['ourMsgInfo'];
  final theirEncryptedMsg = encryptedMsg['theirMsgInfo'];

  // 將加密過的訊息傳回 Server
  for (var deviceId in ourEncryptedMsg.keys) {
    var singleMsg = await returnMsgToServer(deviceId, ourEncryptedMsg[deviceId],
        ourUid, ourUid, theirUid, 'text', msgContent);
    socket.emit('clientSendMsgToServer', jsonEncode(singleMsg));
  }
  for (var deviceId in theirEncryptedMsg.keys) {
    var singleMsg = await returnMsgToServer(
        deviceId,
        theirEncryptedMsg[deviceId],
        theirUid,
        ourUid,
        theirUid,
        'text',
        msgContent);
    socket.emit('clientSendMsgToServer', jsonEncode(singleMsg));
  }
  //發送訊息時，顯示一則新訊息在聊天室
  ChatRoomPageState.currenInstance()?.reloadData();

  print('ready update multiScreen');
//   var multiChatState = MultiChatRoomPageState.currenInstanceInMultiChat();
// if (multiChatState != null) {
//   multiChatState.reloadDataInMulti();
// } else {
//   print('Failed to get MultiChatRoomPageState instance.');
// }
  MultiChatRoomPageState.currenInstanceInMultiChat()?.reloadDataInMulti();
}
