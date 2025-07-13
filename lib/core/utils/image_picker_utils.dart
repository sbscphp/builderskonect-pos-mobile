import 'dart:io';

import 'package:builders_konnect/core/core.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerUtils {
  //image cropper function
  static Future<File?> cropImage({required File? image}) async {
    if (image != null) {
      try {
        CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: image.path,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.white,
              toolbarWidgetColor: Colors.black,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ],
            ),
            IOSUiSettings(
              title: 'Cropper',
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ],
            ),
          ],
        );
        final path = croppedFile!.path;
        return File(path);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  //image picker
  // static Future<File?> pickImage({ImageSource? imageSource}) async {
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? pickedFile = await picker.pickImage(
  //     source: imageSource ?? ImageSource.gallery,
  //     imageQuality: 50,
  //   );
  //   if (pickedFile != null) {
  //     return File(pickedFile.path);
  //   }
  //   return null;
  // }

  static Future<List<File>> pickImage({
    ImageSource source = ImageSource.gallery,
    int imageQuality = 100,
    bool multiImage = false,
  }) async {
    final ImagePicker picker = ImagePicker();
    if (multiImage) {
      final pickedFile = await picker.pickMultiImage(
        imageQuality: imageQuality,
      );
      return pickedFile.map((e) => File(e.path)).toList();
    }

    final pickedFile = await picker.pickImage(
      imageQuality: imageQuality,
      source: source,
    );
    if (pickedFile != null) return [File(pickedFile.path)];
    return [];
  }

  //converts image file to base64 image string
  static Future<String> fileToBase64ImageString({required File? file}) async {
    String base64String = '';
    if (file == null) {
      return base64String;
    }

    List<int> imageBytes = await file.readAsBytes();
    base64String = base64Encode(imageBytes);
    return base64String;
  }

  // //returns the extension of a file/image url
  // static String getFileExtension({required String url}) {

  //   if(url.isEmpty){
  //     return 'jpg';
  //   }

  //   String fileName = url.split('/').last;

  //   return fileName.split('.').last.toLowerCase();
  // }
}
