import 'package:appwrite/appwrite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:smart/feature/create_announcement/data/storage_manager.dart';

import '../../../data/app_repository.dart';
import '../../../models/creating_data.dart';
import '../../../models/models.dart';

class CreatingAnnouncementManager {
  final Client client;
  final Databases databases;
  final Storage storage;
  final Account account;

  CreatingAnnouncementManager({required this.client})
      : databases = Databases(client), account = Account(client), storage = Storage(client);

  CreatingData creatingData = CreatingData();
  SubCategoryItem? currentItem;
  List<XFile> images = [];

  BehaviorSubject<LoadingStateEnum> creatingState = BehaviorSubject<LoadingStateEnum>.seeded(LoadingStateEnum.wait);

  String get prise => (creatingData.price ?? 0).toString();

  void setCategory (String categoryId) => creatingData.categoryId = categoryId;

  void setSubcategory (String subcategoryId) => creatingData.subcategoryId = subcategoryId;

  void setType(bool type) => creatingData.type = type;

  void setItem(SubCategoryItem? newItem, {String? name}) {
    currentItem = newItem ?? SubCategoryItem.withName(name!, creatingData.subcategoryId!)..initialParameters();
    creatingData.itemName = currentItem!.name;
  }

  void setImages(List<XFile> images) {
    creatingData.images = images.map((e) => e.path).toList();
  }

  void setDescription(String description) => creatingData.description = description;

  void setPrice(String price) => creatingData.price = double.parse(price);

  void _setParameters() => creatingData.parameters = currentItem!.parameters.buildJsonFormatParameters();

  void _setTitle() => creatingData.title = currentItem!.title;

  void setInfoFormItem() {
    _setParameters();
    _setTitle();
  }

  void createAnnouncement() async {
    creatingState.add(LoadingStateEnum.loading);
    try {
      final user = await account.get();
      final uid = user.$id;

      final List<String> urls = await uploadImages(creatingData.images ?? []);

      await databases.createDocument(databaseId: postDatabase, collectionId: postCollection, documentId: ID.unique(), data: creatingData.toJason(uid, urls));
      images.clear();
      creatingData.clear;
      creatingState.add(LoadingStateEnum.success);
    } catch (e) {
      creatingState.add(LoadingStateEnum.fail);
      rethrow;
    }
  }

  Future<List<String>> uploadImages(List<String> paths) async {
    List<String> urls = [];

    for (String path in paths) {
      try {
        final file = await storage.createFile(bucketId: anouncmentsImagesId, fileId: ID.unique(), file: InputFile.fromPath(path: path));
        urls.add(createViewUrl(file.$id, file.bucketId));
      // ignore: empty_catches
      } catch (e) {}
    }
    return urls;
  }

  String createViewUrl(String fileID, String bucketID) =>
      'http://89.253.237.166/v1/storage/buckets/$bucketID/files/$fileID/view?project=64987d0f7f186b7e2b45';
}
