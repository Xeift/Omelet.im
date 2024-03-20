// ignore_for_file: avoid_print

import 'package:omelet/message/safe_msg_store.dart';

Future<Map<String, dynamic>> returnMsgToServer(deviceId, singleMsgInfo,
    receiverUid, ourUid, theirUid, msgType, msgContent) async {
  final (cihertext, isPreKeySignalMessage, spkId, opkId) = singleMsgInfo;
  final currentTimestamp = DateTime.now().millisecondsSinceEpoch.toString();

  print('🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃');
  print(cihertext);
  print(isPreKeySignalMessage);
  print(spkId);
  print(opkId);
  print('🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃\n');

  // 將發送的訊息儲存到本地
  final safeMsgStore = SafeMsgStore();
  await safeMsgStore.writeMsg(theirUid, {
    'timestamp': currentTimestamp,
    'type': msgType,
    'sender': ourUid,
    'receiver': theirUid,
    'content': msgContent,
  });
  print('--------------------------------\n');

  // 訊息格式為 PreKeySignalMessage
  if (isPreKeySignalMessage) {
    return {
      'isPreKeySignalMessage': isPreKeySignalMessage,
      'type': msgType,
      'sender': ourUid,
      'receiver': receiverUid,
      'receiverDeviceId': deviceId,
      'content': cihertext,
      'spkId': spkId,
      'opkId': opkId
    };
  }

  // 訊息格式為 SignalMessage
  else {
    return {
      'isPreKeySignalMessage': isPreKeySignalMessage,
      'type': msgType,
      'sender': ourUid,
      'receiver': receiverUid,
      'receiverDeviceId': deviceId,
      'content': cihertext
    };
  }
}
