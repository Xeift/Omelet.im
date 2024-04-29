// ignore_for_file: avoid_print
import 'package:image_picker/image_picker.dart';

import 'package:omelet/api/post/update_pfp_api.dart';

Future<void> onUpdatePfpBtnPressed() async {
  final picker = ImagePicker();
  var image =
      await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

  if (image != null) {
    await updatePfpApi(image.path);
  }
}
