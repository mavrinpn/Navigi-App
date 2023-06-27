import 'package:appwrite/appwrite.dart';
import 'package:rxdart/rxdart.dart';

import '../../../data/app_repository.dart';
import '../../../models/models.dart';

class CreatingManager {
  final Client client;
  final Databases databases;

  CreatingManager({required this.client}) : databases = Databases(client) {
    loadCategories();
  }

  List<Category> categories = [];
  List<SubCategory> subcategories = [];
  List<SubCategoryItem> items = [];
  List<SubCategoryItem> searchItems = [];

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
      subCategoriesState.add(LoadingStateEnum.success);
    } catch (e) {
      subCategoriesState.add(LoadingStateEnum.fail);
      rethrow;
    }
  }

  // Future searchItems(String query, subcategoryId) async {
  //   searchState.add(LoadingStateEnum.loading);
  //   try {
  //     final res = await databases.listDocuments(
  //         databaseId: postDatabase,
  //         collectionId: itemsCollection,
  //         queries: [Query.search('name', query)]);
  //     items.clear();
  //     for (var doc in res.documents) {
  //       items.add(SubCategoryItem.fromJson(doc.data));
  //     }
  //     searchState.add(LoadingStateEnum.success);
  //   } catch (e) {
  //     searchState.add(LoadingStateEnum.fail);
  //     rethrow;
  //   }
  // }
  Future initialLoadItems(String query, subcategoryId) async {
    searchState.add(LoadingStateEnum.loading);
    try {
      final res = await databases.listDocuments(
        databaseId: postDatabase,
        collectionId: itemsCollection,
      );
      items.clear();
      for (var doc in res.documents) {
        items.add(SubCategoryItem.fromJson(doc.data));
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
    for(var item in items){
      if(item.name!.contains(query.toLowerCase())){
        resList.add(item);
      }
    }
    searchItems = resList;

    searchState.add(LoadingStateEnum.success);
  }

  void clearSearchItems(){
    searchItems.clear();
  }
}
