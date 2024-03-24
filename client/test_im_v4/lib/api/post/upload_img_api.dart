import 'package:http/http.dart' as http;

import 'package:test_im_v4/utils/load_local_info.dart';

Future<http.StreamedResponse> uploadImgApi(deviceId, singleMsgInfo, receiverUid,
    ourUid, theirUid, msgType, imgBytes, filename) async {
  final (cihertext, isPreKeySignalMessage, spkId, opkId) = singleMsgInfo;

  final token = await loadJwt();
  var request =
      http.MultipartRequest('POST', Uri.parse('$serverUri/api/v1/upload-img'))
        ..fields['isPreKeySignalMessage'] = isPreKeySignalMessage.toString()
        ..fields['type'] = msgType
        ..fields['sender'] = ourUid
        ..fields['receiver'] = receiverUid
        ..fields['receiverDeviceId'] = deviceId
        // ..fields['content'] = cihertext
        ..fields['spkId'] = spkId.toString()
        ..fields['opkId'] = opkId.toString()
        ..fields['filename'] = filename;
  request.headers.addAll(<String, String>{'Authorization': 'Bearer $token'});
  request.files.add(
      http.MultipartFile.fromString('imgData', cihertext, filename: 'img'));
  var response = await request.send();

  return response;
}
