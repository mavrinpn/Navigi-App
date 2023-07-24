import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:dio/dio.dart';
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

const String apiKey =
    '20f13c781d9882edfdf4eeb06436b7e63aa80ada4da94f6979c13fdde348874bb5b162ce0a34a54911ed93bf04068d556f988eb1868844cbbe1e908c49fadc70f773ab5fc8a5968ad658ad8e4acd5bf3193820bf73fb28ab8d61c74f0373114816c7ba44d7951cbeee3b62040de8b32980b5b6296adc0ab32fb40b83d4aadf5f';

class DatabaseManger {
  final Databases _databases;
  final Functions _functions;
  final Dio _dio;

  DatabaseManger({required Client client})
      : _databases = Databases(client),
        _functions = Functions(client),
        _dio = Dio(BaseOptions(baseUrl: 'http://89.253.237.166/v1', headers: {
          'X-Appwrite-Project': '64987d0f7f186b7e2b45',
          'Content-Type': 'application/json',
          'X-Appwrite-Key': apiKey
        }));

  Future<List<Category>> getAllCategories() async {
    var w = Stopwatch()..start();

    final res = await _databases.listDocuments(
        databaseId: postDatabase, collectionId: categoriesCollection);

    print('------------------------------------------------------------');
    print('${w.elapsed.inMilliseconds}');
    print('------------------------------------------------------------');

    List<Category> categories = [];
    for (var doc in res.documents) {
      categories.add(Category.fromJson(doc.data));
    }

    print('------------------------------------------------------------');
    print('${w.elapsed.inMilliseconds}');
    print('------------------------------------------------------------');
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
    final res = await _functions.createExecution(
        functionId: getAnnouncementFunctionID, data: lastId);

    // final res = await _dio
    //     .post('/functions/$getAnnouncementFunctionID/executions', data: lastId);

    // print(res.data);
    // final response = jsonDecode(res.data['response']);

    final response = jsonDecode(res.response);

    List<Announcement> newAnnounces = [];
    for (var doc in response[responseResult][responseDocuments]) {
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
