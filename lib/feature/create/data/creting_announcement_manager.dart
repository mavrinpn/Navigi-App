import 'dart:developer';
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

  CreatingAnnouncementManager({required this.client})
      : databases = Databases(client);

  CreatingData creatingData = CreatingData();
  SubCategoryItem? currentItem;
  List<XFile> images = [];

  void setCategory (String categoryId) => creatingData.categoryId = categoryId;

  void setIsBy(bool by) => creatingData.type = by;

  void setItem(SubCategoryItem newItem) => currentItem = newItem;

  void setImages(List<XFile> images) {
    creatingData.images = images.map((e) => File(e.path)).toList();
  }
}
