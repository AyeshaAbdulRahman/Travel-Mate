import 'package:image_picker/image_picker.dart';

Future<String?> pickImageFromGallery() async {
  final picker = ImagePicker();
  final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
  return picked?.path;
}
