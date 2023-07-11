import 'package:appwrite/appwrite.dart';
import 'package:smart/models/user.dart';

import '../models/announcement.dart';
import '../models/announcement_creating_data.dart';
import '../models/models.dart';
import '../utils/constants.dart';

const String categoryId = 'categorie_id';
const String subcategoryId = 'sub_category';
const String createdAt = '\$createdAt';
const String totalViews = 'total_views';

class DatabaseManger {
  final Databases _databases;

  DatabaseManger({required Client client}) : _databases = Databases(client);

  Future<List<Category>> getAllCategories() async {
    final res = await _databases.listDocuments(
        databaseId: postDatabase, collectionId: categoriesCollection);

    List<Category> categories = [];
    for (var doc in res.documents) {
      categories.add(Category.fromJson(doc.data));
    }
    return categories;
  }

  Future<List<Subcategory>> getAllSubCategoriesByCategoryId(
      String categoryID) async {
    List<Subcategory> subcategories = <Subcategory>[];
    final res = await _databases.listDocuments(
        databaseId: postDatabase,
        collectionId: subcategoriesCollection,
        queries: [Query.equal(categoryId, categoryID)]);

    for (var doc in res.documents) {
      subcategories.add(Subcategory.fromJson(doc.data));
    }
    return subcategories;
  }

  Future<List<SubCategoryItem>> loadItems(String subcategory) async {
    final res = await _databases.listDocuments(
        databaseId: postDatabase,
        collectionId: itemsCollection,
        queries: [Query.search(subcategoryId, subcategory)]);
    List<SubCategoryItem> items = [];
    for (var doc in res.documents) {
      items.add(SubCategoryItem.fromJson(doc.data)..initialParameters());
    }
    return items;
  }

  Future<List<PlaceData>> getAllPlaces() async {
    final res = await _databases.listDocuments(
        databaseId: placeDatabase, collectionId: placeCollection);

    List<PlaceData> places = [];
    for (var doc in res.documents) {
      places.add(PlaceData.fromJson(doc.data));
    }
    return places;
  }

  Future<List<Announcement>> getLimitAnnouncements(
      String? lastId, int amount) async {
    final res = await _databases.listDocuments(
        databaseId: postDatabase,
        collectionId: postCollection,
        queries: lastId == null
            ? [Query.limit(amount), Query.orderDesc(createdAt)]
            : [Query.limit(amount), Query.cursorAfter(lastId), Query.orderDesc(createdAt)]);

    List<Announcement> newAnnounces = [];
    for (var doc in res.documents) {
      newAnnounces.add(Announcement.fromJson(json: doc.data));
    }

    return newAnnounces;
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
        data: {totalViews: views + 1});
  }

  Future<void> createAnnouncement(
      String uid, List<String> urls, AnnouncementCreatingData creatingData) async {
    await _databases.createDocument(
        databaseId: postDatabase,
        collectionId: postCollection,
        documentId: ID.unique(),
        data: creatingData.toJson(uid, urls));
  }

  Future<void> createUser({required String name, required String uid, required String phone}) async {
    await _databases.createDocument(databaseId: usersDatabase, collectionId: usersCollection, documentId: uid, data: {
      'name': name,
      'phone': phone
    });
  }

  Future<UserData> getUserData({required String uid}) async {
    final res = await _databases.getDocument(databaseId: usersDatabase, collectionId: usersCollection, documentId: uid);
    return UserData.fromJson(res.data);
  }

  Future<void> editProfile({required String uid,  String? name, String? phone, String? imageUrl}) async {
    await _databases.updateDocument(databaseId: usersDatabase, collectionId: usersCollection, documentId: uid, data: {
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (imageUrl != null) 'image': imageUrl
    });
  }
}
