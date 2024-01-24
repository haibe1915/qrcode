import 'package:image_picker/image_picker.dart';

class GetImage {

  static Future<XFile?> getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile;
  }
}
