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
      : databases = Databases(client) {
    loadCategories();
  }

  CreatingData creatingData = CreatingData();
  SubCategoryItem? currentItem;
  List<Category> categories = [];
  List<SubCategory> subcategories = [];
  List<SubCategoryItem> items = [];
  List<SubCategoryItem> searchItems = [];
  List<XFile> images = [];
  String searchController = '';

  BehaviorSubject<LoadingStateEnum> categoriesState =
      BehaviorSubject<LoadingStateEnum>.seeded(LoadingStateEnum.wait);
  BehaviorSubject<LoadingStateEnum> subCategoriesState =
      BehaviorSubject<LoadingStateEnum>.seeded(LoadingStateEnum.wait);
  BehaviorSubject<LoadingStateEnum> searchState =
      BehaviorSubject<LoadingStateEnum>.seeded(LoadingStateEnum.wait);

  Future loadCategories() async {
    categoriesState.add(LoadingStateEnum.loading);
    try {
      final res = await databases.listDocuments(
          databaseId: postDatabase, collectionId: categoriesCollection);

      categories = [];
      for (var doc in res.documents) {
        categories.add(Category.fromJson(doc.data));
      }
      categoriesState.add(LoadingStateEnum.success);
    } catch (e) {
      categoriesState.add(LoadingStateEnum.fail);
      rethrow;
    }
  }

  Future loadSubCategories(String categoryID) async {
    subCategoriesState.add(LoadingStateEnum.loading);
    try {
      subcategories = <SubCategory>[];
      final res = await databases.listDocuments(
          databaseId: postDatabase,
          collectionId: subcategoriesCollection,
          queries: [Query.equal('categorie_id', categoryID)]);
      for (var doc in res.documents) {
        subcategories.add(SubCategory.fromJson(doc.data));
      }
      creatingData.categoryId = categoryID;
      subCategoriesState.add(LoadingStateEnum.success);
    } catch (e) {
      subCategoriesState.add(LoadingStateEnum.fail);
      rethrow;
    }
  }

  Future initialLoadItems(String query, subcategoryId) async {
    searchState.add(LoadingStateEnum.loading);
    try {
      final res = await databases.listDocuments(
        databaseId: postDatabase,
        collectionId: itemsCollection,
        queries: [Query.search('sub_category', subcategoryId)]
      );
      items.clear();
      for (var doc in res.documents) {
        items.add(SubCategoryItem.fromJson(doc.data));
        log(doc.data['name']);
      }
      creatingData.subcategoryId = subcategoryId;
      searchState.add(LoadingStateEnum.success);
    } catch (e) {
      searchState.add(LoadingStateEnum.fail);
      rethrow;
    }
  }

  void searchItemsByName(String query) {
    searchState.add(LoadingStateEnum.loading);

    List<SubCategoryItem> resList = [];
    for (var item in items) {
      if (item.name!.toLowerCase().contains(query.toLowerCase())) {
        resList.add(item);
      }
    }
    searchItems = resList;

    searchState.add(LoadingStateEnum.success);
  }

  void clearSearchItems() {
    searchItems.clear();
  }

  void setSearchController(String value) {
    searchController = value;
  }

  void setIsBy(bool value) {
    creatingData.type = value;
  }

  void setItem(SubCategoryItem newItem) => currentItem = newItem;

  void setImages(List<XFile> images) {
    creatingData.images = images.map((e) => File(e.path)).toList();
  }
}
