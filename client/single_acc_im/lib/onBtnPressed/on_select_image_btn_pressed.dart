// ignore_for_file: avoid_print
import 'package:image_picker/image_picker.dart';

late String? imagePath;

Future<void> onSelectImageBtnPressed(Function updateHintMsg) async {
  final picker = ImagePicker();
  var image = await picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    imagePath = image.path;
  } else {
    imagePath = null;
    print('No image selected.');
  }
}

void resetImagePath() {
  imagePath = null;
}
