// 上傳和更新自身頭像用

import 'package:http/http.dart' as http;

import 'package:omelet/utils/load_local_info.dart';

Future<http.StreamedResponse> updatePfpApi(String path) async {
  final token = await loadJwt();
  var request =
      http.MultipartRequest('POST', Uri.parse('$serverUri/api/v1/update-pfp'));
  request.headers.addAll(<String, String>{'Authorization': 'Bearer $token'});
  request.files.add(await http.MultipartFile.fromPath('pfpData', path));
  var response = await request.send();

  return response;
}
