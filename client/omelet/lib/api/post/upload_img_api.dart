// 使用者上傳圖片用

import 'package:http/http.dart' as http;

import 'package:omelet/utils/load_local_info.dart';

Future<http.StreamedResponse> uploadImgApi(deviceId, singleMsgInfo, receiverUid,
    ourUid, theirUid, imgBytes, filename) async {
  final (cihertext, isPreKeySignalMessage, spkId, opkId) = singleMsgInfo;

  final token = await loadJwt();
  http.MultipartRequest request;

  // 訊息格式為 PreKeySignalMessage
  if (isPreKeySignalMessage) {
    request =
        http.MultipartRequest('POST', Uri.parse('$serverUri/api/v1/upload-img'))
          ..fields['isPreKeySignalMessage'] = isPreKeySignalMessage.toString()
          ..fields['type'] = 'image'
          ..fields['sender'] = ourUid
          ..fields['receiver'] = receiverUid
          ..fields['receiverDeviceId'] = deviceId
          ..fields['content'] = filename
          ..fields['spkId'] = spkId.toString()
          ..fields['opkId'] = opkId.toString();
  }

  // 訊息格式為 SignalMessage
  else {
    request =
        http.MultipartRequest('POST', Uri.parse('$serverUri/api/v1/upload-img'))
          ..fields['isPreKeySignalMessage'] = isPreKeySignalMessage.toString()
          ..fields['type'] = 'image'
          ..fields['sender'] = ourUid
          ..fields['receiver'] = receiverUid
          ..fields['receiverDeviceId'] = deviceId
          ..fields['content'] = filename
          ..fields['spkId'] = spkId.toString()
          ..fields['opkId'] = opkId.toString();
  }
  request.headers.addAll(<String, String>{'Authorization': 'Bearer $token'});
  request.files.add(
      http.MultipartFile.fromString('imgData', cihertext, filename: 'img'));
  var response = await request.send();

  return response;
}
