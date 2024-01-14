import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:smart/feature/announcement_editing/data/models/image_data.dart';

class EditImages {
  final List<ImageData> _deletedImages = [];
  final List<ImageData> _addedImages = [];
  final List<ImageData> _currentAnnouncementImages = [];

  List<ImageData> get currentImages {
    final images = <ImageData>[];

    for (var image in _currentAnnouncementImages) {
      if (!_deletedImages.contains(image)) {
        images.add(image);
      }
    }
    images.addAll(_addedImages);

    return images;
  }

  void addCurrentImages(List<ImageData> images) =>
      _currentAnnouncementImages.addAll(images);

  void deleteImage(ImageData image) {
    if (_addedImages.contains(image)) {
      _addedImages.remove(image);
    }
    if (_currentAnnouncementImages.contains(image) &&
        !_deletedImages.contains(image)) {
      _deletedImages.add(image);
    }
  }

  void addImage(Uint8List imageAsBytes) {
    _addedImages.add(ImageData.newImage(imageAsBytes));
  }

  Future<List<Uint8List>> getNewImages() async {
    await _compressImages();
    return List.generate(
        _addedImages.length, (index) => _addedImages[index].bytes);
  }

  List<String> deletedImages() {
    return List.generate(
        _deletedImages.length, (index) => _deletedImages[index].id!);
  }

  void clear() {
    _currentAnnouncementImages.clear();
    _deletedImages.clear();
    _addedImages.clear();
  }

  Future<void> _compressImages() async {
    for (var image in _addedImages) {
      if (!image.compressed) {
        final compressedImageBytes = await _compressImage(image.bytes);
        image.compressed = true;
        image.bytes = compressedImageBytes;
      }
    }
  }

  Future<Uint8List> _compressImage(Uint8List list) =>
      FlutterImageCompress.compressWithList(
        list,
        minWidth: 400,
        quality: 96,
      );
}
