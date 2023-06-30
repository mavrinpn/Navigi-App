import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';

import '../../../data/app_repository.dart';
import '../../../models/creating_data.dart';
import '../../../models/models.dart';

class CreatingAnnouncementManager {
  final Client client;
  final Databases databases;
  final Account account;

  CreatingAnnouncementManager({required this.client})
      : databases = Databases(client), account = Account(client);

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
    creatingData.images = images.map((e) => File(e.path)).toList();
  }

  void setDescription(String description) => creatingData.description = description;

  void setPrice(String price) => creatingData.price = double.parse(price);

  void _setParameters() => creatingData.parameters = currentItem!.itemParameters.buildJsonFormatParameters();

  void _setTitle() => creatingData.title = currentItem!.getTitle();

  void setInfoFormItem() {
    _setParameters();
    _setTitle();
  }

  void createAnounce() async {
    creatingState.add(LoadingStateEnum.loading);
    try {
      final user = await account.get();
      final uid = user.$id;
      await databases.createDocument(databaseId: postDatabase, collectionId: postCollection, documentId: ID.unique(), data: creatingData.toJason(uid));
      images.clear();
      creatingData.clear;
      creatingState.add(LoadingStateEnum.success);
    } catch (e) {
      creatingState.add(LoadingStateEnum.fail);
      rethrow;
    }
  }

}
