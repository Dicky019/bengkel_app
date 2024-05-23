import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImageService extends ImagePicker {
  Future<ImageServiceModel?> pickImageFile({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  }) async {
    final imageX = await super.pickImage(
      source: source,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
      preferredCameraDevice: preferredCameraDevice,
      requestFullMetadata: requestFullMetadata,
    );

    if (imageX == null) {
      return null;
    }

    final result =
        ImageServiceModel(file: File(imageX.path), name: imageX.name);

    return result;
  }
}

class ImageServiceModel {
  final File file;
  final String name;

  ImageServiceModel({required this.file, required this.name});
}
