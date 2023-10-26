// ignore_for_file: avoid_print

import 'safe_msg_store.dart';

Future<void> onSaveMsgBtnPressed(String uid) async {
  final safeMsgStore = SafeMsgStore();
  await safeMsgStore.writeMsg(uid, {
    "_id": "65390ef1d9b39ec893d6e4e4",
    "timestamp": 1698143242,
    "type": "text",
    "receiver": "491437500754038784",
    "sender": "504619688634880000",
    "content": "原神啟動",
    "__v": 0
  });
  await safeMsgStore.writeMsg(
    uid,
    {
      "_id": "65390ef1d9b39ec893d6e4e7",
      "timestamp": 1698143246,
      "type": "text",
      "receiver": "491437500754038784",
      "sender": "504620939263086593",
      "content": "蹦蹦炸彈",
      "__v": 0
    },
  );
}

Future<void> onReadMsgBtnPressed(String uid) async {
  final safeMsgStore = SafeMsgStore();
  final msg = await safeMsgStore.readMsg(uid, 1);
  print(msg);
}

Future<void> onGetUnreadMsgBtnPressed(String uid) async {
  print('read unread');
}
