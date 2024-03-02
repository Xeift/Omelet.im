// ignore_for_file: avoid_print
import './../api/post/update_pfp.dart';
import 'package:image_picker/image_picker.dart';

Future<void> onTestBtn2Pressed(Function updateHintMsg) async {
  final picker = ImagePicker();
  var image = await picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    final res = await updatePfp(image.path);
    if (res.statusCode == 200) {
      print('[on_test_btn2Pressed.dart] update pfp successfully');
    }
  } else {
    print('No image selected.');
  }
}
