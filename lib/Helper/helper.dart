// ignore_for_file: no_leading_underscores_for_local_identifiers, unnecessary_nullable_for_final_variable_declarations
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Helper {
  //getter to get the image outside of this class
  File? _imageFromGallery;
  File? get imageFromGallery => _imageFromGallery;

  File? _imageFromCamera;
  File? get imageFromCamera => _imageFromCamera;
  //getter to get the images outside of this class
  final List<XFile>? _multipleImagesFromGallery = [];
  List<XFile>? get multipleImagesFromGallery => _multipleImagesFromGallery;

  Future getSingleImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    final imageTemporary = File(image.path);

    _imageFromGallery = imageTemporary;
    return _imageFromGallery;
  }

  Future getMultipleImages() async {
    final List<XFile>? pickMultipleImages =
        await ImagePicker().pickMultiImage();

    if (pickMultipleImages!.isEmpty) return [];

    if (pickMultipleImages.isNotEmpty) {
      _multipleImagesFromGallery!.addAll(pickMultipleImages);
    }
  }

  Future getCameraImages() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return null;

    final temporaryImage = File(image.path);
    _imageFromCamera = temporaryImage;
    return _imageFromCamera;
  }
}
