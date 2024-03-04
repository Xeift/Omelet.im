// ignore_for_file: avoid_print
import 'package:image_picker/image_picker.dart';

Future<void> onSelectImageBtnPressed(Function updateHintMsg) async {
  final picker = ImagePicker();
  var image = await picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    print(image.path);
  } else {
    print('No image selected.');
  }
}
