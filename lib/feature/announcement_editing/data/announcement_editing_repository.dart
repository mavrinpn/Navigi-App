import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:smart/feature/announcement_editing/data/models/edit_data.dart';
import 'package:smart/feature/announcement_editing/data/models/image_data.dart';
import 'package:smart/feature/announcement_editing/data/images.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/services/database/database_service.dart';
import 'package:smart/services/storage_service.dart';
import 'package:smart/utils/constants.dart';
import 'package:smart/utils/price_type.dart';

class AnnouncementEditingRepository {
  final DatabaseService _databaseService;
  final FileStorageManager _storageManager;
  final _picker = ImagePicker();

  AnnouncementEditingRepository(
      DatabaseService databaseService, FileStorageManager storageManager)
      : _databaseService = databaseService,
        _storageManager = storageManager;

  Announcement? _currentAnnouncement;

  AnnouncementEditData? editData;
  EditImages images = EditImages();

  List<ImageData> get currentImages => images.currentImages;

  void closeEdit() {
    editData = null;
    images.clear();
  }

  Future<void> deleteAnnouncement(String announcementId) =>
      _databaseService.announcements.deleteAnnouncement(announcementId);

  Future<void> setAnnouncementForEdit(Announcement announcement) async {
    _currentAnnouncement = announcement;
    editData = AnnouncementEditData.fromAnnouncement(announcement);

    images.clear();
    await _getCurrentAnnouncementImages();
  }

  void deleteImage(ImageData image) => images.deleteImage(image);

  /// нахуй не надо
  void addImage(Uint8List imageAsBytes) => images.addImage(imageAsBytes);

  void setTitle(String newValue) => editData!.title = newValue;

  void setPlace(CityDistrict newPlace) {
    editData!.cityId = newPlace.cityId;
    editData!.areaId = newPlace.id;
  }

  void setDescription(String newValue) => editData!.description = newValue;

  void setPrice(double newValue) => editData!.price = newValue;
  void setPriceType(PriceType newValue) => editData!.priceType = newValue;

  Future<void> pickImages() async {
    final resImages = await _picker.pickMultiImage();
    for (var im in resImages) {
      images.addImage(await im.readAsBytes());
    }
  }

  Future saveChanges() async {
    await _saveImagesChanges();
    await _databaseService.announcements.editAnnouncement(editData!);
  }

  Future _saveImagesChanges() async {
    final newImagesUrls = await _uploadNewImages();
    editData!.images.addAll(newImagesUrls);
    await _deleteImages();
  }

  Future<List<String>> _uploadNewImages() async {
    final bytesList = await images.getNewImages();
    final urls = await _storageManager.uploadAnnouncementImages(bytesList);
    return urls;
  }

  Future<void> _deleteImages() async {
    final deletedIds = images.deletedImages();
    for (String id in deletedIds) {
      final fileUrl = _storageManager.createViewUrl(id, announcementsBucketId);
      editData!.images.remove(fileUrl);
      await _storageManager.deleteImage(id, announcementsBucketId);
    }
  }

  Future _getCurrentAnnouncementImages() async {
    final newImages = <ImageData>[];

    for (var imageUrl in _currentAnnouncement!.images) {
      final String id = getIdFromUrl(imageUrl);
      final Uint8List bytes =
          await _databaseService.announcements.getAnnouncementImage(imageUrl);

      newImages.add(ImageData(id, bytes));
    }

    images.addCurrentImages(newImages);
  }
}
