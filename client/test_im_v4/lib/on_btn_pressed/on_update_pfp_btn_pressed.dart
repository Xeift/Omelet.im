// ignore_for_file: avoid_print
import 'package:image_picker/image_picker.dart';

import 'package:test_im_v4/api/post/update_pfp_api.dart';

Future<void> onUpdatePfpBtnPressed(Function updateHintMsg) async {
  final picker = ImagePicker();
  var image = await picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    final res = await updatePfpApi(image.path);
    if (res.statusCode == 200) {
      print('[on_test_btn2Pressed.dart] update pfp successfully');
    }
  } else {
    print('No image selected.');
  }
}
