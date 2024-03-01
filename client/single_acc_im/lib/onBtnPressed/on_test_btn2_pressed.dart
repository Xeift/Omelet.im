// ignore_for_file: avoid_print
import './../api/post/update_pfp.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

Future<void> onTestBtn2Pressed(Function updateHintMsg) async {
  final picker = ImagePicker();
  var image = await picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    // final bytes = await File(image.path).readAsBytes();
    // final img64 = base64Encode(bytes);
    // final res = await updatePfp(img64);
    // final imgJson = jsonEncode(bytes);
    // final res = await updatePfp(imgJson);

    final res = await updatePfp(image.path);
    print(res.statusCode);
  } else {
    print('No image selected.');
  }
}
