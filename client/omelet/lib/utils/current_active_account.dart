import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

Future<bool> isCurrentActiveAccountExsist() async {
  return (await storage.read(key: 'currentActiveAccount')) != null;
}
