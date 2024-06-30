import 'dart:typed_data';

import 'package:smart/feature/announcement_editing/data/models/image_data.dart';
import 'package:smart/utils/image_compress.dart';

class EditImages {
  final List<ImageData> _deletedImages = [];
  final List<ImageData> _addedImages = [];
  final List<ImageData> _currentAnnouncementImages = [];
  late ImageData _thumbImage;

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

  void addCurrentImages(List<ImageData> images, ImageData thumb) {
    _currentAnnouncementImages.addAll(images);
    _thumbImage = thumb;
  }

  void deleteImage(ImageData image) {
    if (_addedImages.contains(image)) {
      _addedImages.remove(image);
    }
    if (_currentAnnouncementImages.contains(image) && !_deletedImages.contains(image)) {
      _deletedImages.add(image);
    }
  }

  void addImage(Uint8List imageAsBytes) {
    _addedImages.add(ImageData.newImage(imageAsBytes));
  }

  Future<List<Uint8List>> getNewImages() async {
    await _compressImages();
    return List.generate(_addedImages.length, (index) => _addedImages[index].bytes);
  }

  Future<Uint8List> getThumbImage() async {
    await _compressThumb();
    return _thumbImage.bytes;
  }

  List<String> deletedImages() {
    return List.generate(_deletedImages.length, (index) => _deletedImages[index].id!);
  }

  String? thumbImage() {
    return _thumbImage.id;
  }

  void clear() {
    _currentAnnouncementImages.clear();
    _deletedImages.clear();
    _addedImages.clear();
  }

  Future<void> _compressImages() async {
    for (var image in _addedImages) {
      if (!image.compressed) {
        final compressedImageBytes = await resizeAndcompressImage(image.bytes);
        image.compressed = true;
        image.bytes = compressedImageBytes;
      }
    }
  }

  Future<void> _compressThumb() async {
    final resultImages = [..._currentAnnouncementImages, ..._addedImages];
    final deletedIds = _deletedImages.map((e) => e.id).toList();
    resultImages.removeWhere((e) => deletedIds.contains(e.id));

    _thumbImage = ImageData(
      resultImages.first.id,
      resultImages.first.bytes,
      compressed: false,
    );
    if (!_thumbImage.compressed) {
      final compressedImageBytes = await resizeAndcompressThumb(_thumbImage.bytes);
      _thumbImage.compressed = true;
      _thumbImage.bytes = compressedImageBytes;
    }
  }
}
