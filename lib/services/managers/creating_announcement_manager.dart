import 'package:appwrite/appwrite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/app_repository.dart';
import '../../models/announcement_creating_data.dart';
import '../../models/models.dart';
import '../database_manager.dart';
import '../file_storage.dart';

class CreatingAnnouncementManager {
  final Client client;
  final DatabaseManger dbManager;
  final FileStorageManager storageManager;
  final Account account;

  CreatingAnnouncementManager({required this.client})
      : dbManager = DatabaseManger(client: client),
        account = Account(client),
        storageManager = FileStorageManager(client: client);

  AnnouncementCreatingData creatingData = AnnouncementCreatingData();
  SubCategoryItem? currentItem;
  List<XFile> images = [];

  BehaviorSubject<LoadingStateEnum> creatingState =
      BehaviorSubject<LoadingStateEnum>.seeded(LoadingStateEnum.wait);

  String get prise => (creatingData.price ?? 0).toString();

  void setCategory(String categoryId) => creatingData.categoryId = categoryId;

  void setSubcategory(String subcategoryId) =>
      creatingData.subcategoryId = subcategoryId;

  void setType(bool type) => creatingData.type = type;

  void setItem(SubCategoryItem? newItem, {String? name}) {
    currentItem =
        newItem ?? SubCategoryItem.withName(name!, creatingData.subcategoryId!)
          ..initialParameters();
    creatingData.itemName = currentItem!.name;
  }

  void setPlaceById(String id) =>  creatingData.placeId = id;

  void setImages(List<XFile> images) {
    creatingData.images = images.map((e) => e.path).toList();
  }

  void setDescription(String description) =>
      creatingData.description = description;

  void setPrice(String price) => creatingData.price = double.parse(price);

  void _setParameters() => creatingData.parameters =
      currentItem!.parameters.buildJsonFormatParameters();


  String get buildTitle => currentItem!.title;

  void setTitle(String title) => creatingData.title = title;

  void setInfoFormItem() {
    _setParameters();
  }

  void createAnnouncement() async {
    creatingState.add(LoadingStateEnum.loading);
    try {
      final user = await account.get();
      final uid = user.$id;
      final List<String> urls = await uploadImages(creatingData.images ?? []);

      await dbManager.createAnnouncement(uid, urls, creatingData);

      images.clear();
      creatingData.clear;
      creatingState.add(LoadingStateEnum.success);
    } catch (e) {
      creatingState.add(LoadingStateEnum.fail);
      rethrow;
    }
  }

  Future<List<String>> uploadImages(List<String> paths) async =>
      await storageManager.uploadImages(paths);
}
