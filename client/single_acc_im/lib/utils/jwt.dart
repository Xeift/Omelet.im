import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// import './../api/post/check_jwt_status_api.dart';

const storage = FlutterSecureStorage();

Future<bool> isJwtExsist() async {
  return (await storage.read(key: 'token')) != null;
}

// Future<bool> isJwtValid() async {
//   final res = await checkJwtStatusAPI();
//   if (res.statusCode == 200) {
//     return true;
//   } else {
//     return false;
//   }
// }
