import 'dart:convert';

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

const String userName = 'name';
const String userPhone = 'phone';
const String userImageUrl = 'image';

class DatabaseManger {
  final Databases _databases;
  final Functions _functions;

  DatabaseManger({required Client client})
      : _databases = Databases(client),
        _functions = Functions(client);

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

  Future<List<Announcement>> getLimitAnnouncements(String? lastId) async {
    final start = DateTime.now();
    final res = await _functions.createExecution(
        functionId: getAnnouncementFunctionID, data: lastId);
    List<Announcement> newAnnounces = [];
    for (var doc in jsonDecode(res.response)[responseResult]
        [responseDocuments]) {
      newAnnounces.add(Announcement.fromJson(json: doc));
    }
    return newAnnounces;
  }

  Future<Announcement> getAnnouncementById(String id) async {
    final res = await _databases.getDocument(
        databaseId: postDatabase, collectionId: postCollection, documentId: id);
    final announcement = Announcement.fromJson(json: res.data);
    return announcement;
  }

  Future<void> incTotalViewsById(String id) async {
    final res = await _databases.getDocument(
        databaseId: postDatabase, collectionId: postCollection, documentId: id);

    await _databases.updateDocument(
        databaseId: postDatabase,
        collectionId: postCollection,
        documentId: id,
        data: {totalViews: res.data[totalViews] + 1});
  }

  Future<void> createAnnouncement(String uid, List<String> urls,
      AnnouncementCreatingData creatingData) async {
    await _databases.createDocument(
        databaseId: postDatabase,
        collectionId: postCollection,
        documentId: ID.unique(),
        data: creatingData.toJson(uid, urls));
  }

  Future<void> createUser(
      {required String name,
      required String uid,
      required String phone}) async {
    await _databases.createDocument(
        databaseId: usersDatabase,
        collectionId: usersCollection,
        documentId: uid,
        data: {userName: name, userPhone: phone});
  }

  Future<UserData> getUserData({required String uid}) async {
    final res = await _databases.getDocument(
        databaseId: usersDatabase,
        collectionId: usersCollection,
        documentId: uid);
    return UserData.fromJson(res.data);
  }

  Future<void> editProfile(
      {required String uid,
      String? name,
      String? phone,
      String? imageUrl}) async {
    await _databases.updateDocument(
        databaseId: usersDatabase,
        collectionId: usersCollection,
        documentId: uid,
        data: {
          if (name != null) userName: name,
          if (phone != null) userPhone: phone,
          if (imageUrl != null) userImageUrl: imageUrl
        });
  }
}
