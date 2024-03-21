// ignore_for_file: avoid_print

Future<Map<String, dynamic>> returnMsgToServer(deviceId, singleMsgInfo,
    receiverUid, ourUid, theirUid, msgType, msgContent) async {
  final (cihertext, isPreKeySignalMessage, spkId, opkId) = singleMsgInfo;

  print('🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃');
  print(cihertext);
  print(isPreKeySignalMessage);
  print(spkId);
  print(opkId);
  print('🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃\n');

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
