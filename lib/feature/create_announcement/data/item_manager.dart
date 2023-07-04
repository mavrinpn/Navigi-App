import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:rxdart/rxdart.dart';

import '../../../data/app_repository.dart';
import '../../../models/item.dart';
import '../../../utils/constants.dart';

class ItemManager {
  final Client client;
  final Databases databases;

  ItemManager({required this.client}) : databases = Databases(client);

  List<SubCategoryItem> items = [];
  List<SubCategoryItem> searchedItems = [];
  String searchController = '';

  BehaviorSubject<LoadingStateEnum> searchState =
      BehaviorSubject<LoadingStateEnum>.seeded(LoadingStateEnum.wait);

  Future initialLoadItems(String query, subcategoryId) async {
    searchState.add(LoadingStateEnum.loading);
    try {
      final res = await databases.listDocuments(
          databaseId: postDatabase,
          collectionId: itemsCollection,
          queries: [Query.search('sub_category', subcategoryId)]);
      items.clear();
      for (var doc in res.documents) {
        items.add(SubCategoryItem.fromJson(doc.data)..initialParameters());
        log(doc.data['name']);
      }
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
      if (item.name.toLowerCase().contains(query.toLowerCase())) {
        resList.add(item);
      }
    }
    searchedItems = resList;

    searchState.add(LoadingStateEnum.success);
  }

  void clearSearchItems() {
    searchedItems.clear();
  }

  void setSearchController(String value) {
    searchController = value;
  }

  SubCategoryItem? hasItemInSearchedItems() {
    for (var item in searchedItems) {
      if (searchController == item.name) {
        return item;
      }
    }
    return null;
  }
}
