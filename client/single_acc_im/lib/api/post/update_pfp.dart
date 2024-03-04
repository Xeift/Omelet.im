import 'package:http/http.dart' as http;

import './../../utils/load_jwt.dart';
import './../../utils/server_uri.dart';

Future<http.StreamedResponse> updatePfp(String path) async {
  final token = await loadJwt();
  var request =
      http.MultipartRequest('POST', Uri.parse('$serverUri/api/v1/update-pfp'));
  request.headers.addAll(<String, String>{'Authorization': 'Bearer $token'});
  request.files.add(await http.MultipartFile.fromPath('pfpData', path));
  var response = await request.send();

  return response;
}
