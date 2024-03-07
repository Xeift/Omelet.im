import 'package:http/http.dart' as http;

import 'package:test_im_v4/utils/load_local_info.dart';

Future<http.StreamedResponse> updatePfp(String path) async {
  final token = await loadJwt();
  var request =
      http.MultipartRequest('POST', Uri.parse('$serverUri/api/v1/update-pfp'));
  request.headers.addAll(<String, String>{'Authorization': 'Bearer $token'});
  request.files.add(await http.MultipartFile.fromPath('pfpData', path));
  var response = await request.send();

  return response;
}
