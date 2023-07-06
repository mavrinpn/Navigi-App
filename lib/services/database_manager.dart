import 'package:appwrite/appwrite.dart';

import '../models/models.dart';
import '../utils/constants.dart';

class DatabaseManger {
  final Databases _databases;

  DatabaseManger({required Client client}) : _databases = Databases(client);


  Future<List<Category>> loadCategories() async {
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

  Future<List<Subcategory>> loadSubCategories(String categoryID) async {
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
}