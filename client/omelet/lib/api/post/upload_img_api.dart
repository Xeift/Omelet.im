// 使用者上傳圖片用

import 'package:http/http.dart' as http;

import 'package:omelet/utils/server_uri.dart';
import 'package:omelet/storage/safe_account_store.dart';
import 'package:omelet/storage/safe_device_id_store.dart';

Future<http.StreamedResponse> uploadImgApi(isPreKeySignalMessage, sender,
    receiver, receiverDeviceId, content, filename) async {
  final token = await loadJwt();
  final safeDeviceIdStore = SafeDeviceIdStore();
  final senderDeviceId = await safeDeviceIdStore.getLocalDeviceId();
  http.MultipartRequest request;

  request =
      http.MultipartRequest('POST', Uri.parse('$serverUri/api/v1/upload-img'))
        ..fields['isPreKeySignalMessage'] = isPreKeySignalMessage.toString()
        ..fields['type'] = 'image'
        ..fields['sender'] = sender
        ..fields['senderDeviceId'] = senderDeviceId
        ..fields['receiver'] = receiver
        ..fields['receiverDeviceId'] = receiverDeviceId
        ..fields['content'] = filename;

  request.headers.addAll(<String, String>{'Authorization': 'Bearer $token'});
  request.files
      .add(http.MultipartFile.fromString('imgData', content, filename: 'img'));
  var response = await request.send();

  return response;
}
