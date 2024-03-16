import 'package:http/http.dart' as http;

import 'package:test_im_v4/utils/load_local_info.dart';

Future<http.StreamedResponse> uploadImgApi(
    String encryptedBytes, String receiverUid) async {
  final token = await loadJwt();
  var request =
      http.MultipartRequest('POST', Uri.parse('$serverUri/api/v1/upload-img'))
        ..fields['receiverUid'] = receiverUid;
  request.headers.addAll(<String, String>{'Authorization': 'Bearer $token'});
  request.files.add(http.MultipartFile.fromString('imgData', encryptedBytes));
  var response = await request.send();

  return response;
}
