import 'package:appwrite/appwrite.dart';

import '../models/announcement.dart';
import '../models/creating_data.dart';
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

  Future<List<Subcategory>> getAllSubCategoriesByCategoryId(
      String categoryID) async {
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

  Future<List<Announcement>> getLimitAnnouncements(
      String? lastId, int amount) async {
    try {
      final res = await _databases.listDocuments(
          databaseId: postDatabase,
          collectionId: postCollection,
          queries: lastId == null
              ? [Query.limit(amount)]
              : [Query.limit(amount), Query.cursorAfter(lastId)]);

      List<Announcement> newAnnounces = [];
      for (var doc in res.documents) {
        newAnnounces.add(Announcement.fromJson(json: doc.data));
      }

      return newAnnounces;
    } catch (e) {
      if (e.toString() != 'Bad state: No element') {
        rethrow;
      }
    }
    return [];
  }

  Future<Announcement> getAnnouncementById(String id) async {
    final res = await _databases.getDocument(
        databaseId: postDatabase, collectionId: postCollection, documentId: id);
    final announcement = Announcement.fromJson(json: res.data);
    return announcement;
  }

  Future<void> incTotalViewsById(String id, int views) async {
    await _databases.updateDocument(
        databaseId: postDatabase,
        collectionId: postCollection,
        documentId: id,
        data: {'total_views': views + 1});
  }

  Future<void> createAnnouncement(String uid, List<String> urls, CreatingData creatingData) async {
    await _databases.createDocument(
        databaseId: postDatabase,
        collectionId: postCollection,
        documentId: ID.unique(),
        data: creatingData.toJason(uid, urls));
  }
}
