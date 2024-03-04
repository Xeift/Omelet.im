// ignore_for_file: avoid_print
import 'package:image_picker/image_picker.dart';

late String imagePath;

Future<void> onSelectImageBtnPressed(Function updateHintMsg) async {
  final picker = ImagePicker();
  var image = await picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    imagePath = image.path;
    print('[on_select_image_btn_pressed.dart]imagePath: $imagePath');
  } else {
    print('No image selected.');
  }
}
