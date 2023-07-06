import 'package:appwrite/appwrite.dart';

import '../models/models.dart';
import '../utils/constants.dart';

class DatabaseManger {
  final Databases _databases;

  DatabaseManger({required Client client}) : _databases = Databases(client);


  Future<List<Category>> getAllCategories() async {
    try {
      final res = await _databases.listDocuments(
          databaseId: postDatabase, collectionId: categoriesCollection);

      List<Category> categories = [];
      for (var doc in res.documents) {
        categories.add(Category.fromJson(doc.data));
      }
      return categories;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Subcategory>> getAllSubCategoriesByCategoryId(String categoryID) async {
    try {
      List<Subcategory> subcategories = <Subcategory>[];
      final res = await _databases.listDocuments(
          databaseId: postDatabase,
          collectionId: subcategoriesCollection,
          queries: [Query.equal('categorie_id', categoryID)]);

      for (var doc in res.documents) {
        subcategories.add(Subcategory.fromJson(doc.data));
      }
      return subcategories;

    } catch (e) {
      rethrow;
    }
  }

  Future<List<SubCategoryItem>> loadItems(String subcategory) async {
    final res = await _databases.listDocuments(
        databaseId: postDatabase,
        collectionId: itemsCollection,
        queries: [Query.search('sub_category', subcategory)]);
    List<SubCategoryItem> items = [];
    for (var doc in res.documents) {
      items.add(SubCategoryItem.fromJson(doc.data)..initialParameters());
    }
    return items;
  }
}