// ignore_for_file: avoid_print
import 'package:image_picker/image_picker.dart';

import 'package:omelet/api/post/update_pfp_api.dart';

Future<void> onUpdatePfpBtnPressed() async {
  final picker = ImagePicker();
  var image = await picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    final res = await updatePfpApi(image.path);
    if (res.statusCode == 200) {
      print('[on_update_pfp_btn_pressed.dart] update pfp successfully');
    }
  } else {
    print('No image selected.');
  }
}
