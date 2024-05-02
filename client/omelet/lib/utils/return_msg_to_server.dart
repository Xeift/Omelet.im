// ignore_for_file: avoid_print
import 'package:omelet/storage/safe_account_store.dart';

Future<Map<String, dynamic>> returnMsgToServer(deviceId, singleMsgInfo,
    receiverUid, ourUid, theirUid, msgType, msgContent) async {
  final (cihertext, isPreKeySignalMessage, spkId, opkId) = singleMsgInfo;
  final ipkPub = await loadIpkPub();

  // 訊息格式為 PreKeySignalMessage
  if (isPreKeySignalMessage) {
    return {
      'isPreKeySignalMessage': isPreKeySignalMessage,
      'type': msgType,
      'sender': ourUid,
      'senderIpkPub': ipkPub,
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
      'senderIpkPub': ipkPub,
      'sender': ourUid,
      'receiver': receiverUid,
      'receiverDeviceId': deviceId,
      'content': cihertext
    };
  }
}
