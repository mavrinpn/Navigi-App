import 'dart:convert';
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smart/models/user.dart';

import '../models/announcement.dart';
import '../models/announcement_creating_data.dart';
import '../models/models.dart';
import '../utils/constants.dart';

const String categoryId = 'categoryId';
const String subcategoryId = 'subcategory';
const String createdAt = '\$createdAt';
const String totalViews = 'total_views';

const String userName = 'name';
const String userPhone = 'phone';
const String userImageUrl = 'image_url';

final String apiKey = dotenv.get('apiKey');

class DatabaseService {
  final Databases _databases;
  final Functions _functions;
  final Storage _storage;
  final Client _client;
  final Dio _dio;

  DatabaseService({required Client client})
      : _client = client,
        _databases = Databases(client),
        _functions = Functions(client),
        _storage = Storage(client),
        _dio = Dio(BaseOptions(baseUrl: 'http://89.253.237.166/v1', headers: {
          'X-Appwrite-Project': '64987d0f7f186b7e2b45',
          'Content-Type': 'application/json',
          'X-Appwrite-Key': apiKey
        }));

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

  Future<List<SubCategoryItem>> loadItemsBySubcategory(
      String subcategory) async {
    final res = await _databases.listDocuments(
        databaseId: postDatabase,
        collectionId: itemsCollection,
        queries: [Query.equal(subcategoryId, subcategory)]);
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

  _getIdFromUrl(String url) {
    final split = url.split('/');
    return split[split.length - 2];
  }

  Future searchItemByQuery(String query) async {
    final List<String> queries = [
      Query.search('name', query),
      Query.limit(40),
    ];
    final res = await _databases.listDocuments(
        databaseId: postDatabase,
        collectionId: itemsCollection,
        queries: queries);
    List<SubCategoryItem> items = [];
    for (var doc in res.documents) {
      items.add(SubCategoryItem.fromJson(doc.data));
    }
    return items;
  }

  Future<List<String>> popularQueries() async {
    final res = await _databases.listDocuments(
        databaseId: postDatabase, collectionId: 'queries');

    return res.documents.map((e) => e.data['name'].toString()).toList();
  }

  Future<List<Announcement>> loadLimitAnnouncements(String? lastId) async {
    Map<String, dynamic> query = {};

    if ((lastId ?? '').isEmpty) lastId = null;

    if (lastId != null) query['lastID'] = lastId;

    final res = await _functions.createExecution(
        functionId: getAnnouncementFunctionID, data: jsonEncode(query));

    final response = jsonDecode(res.response);

    List<Announcement> newAnnounces = [];
    for (var doc in response[responseDocuments]) {
      final id = _getIdFromUrl(doc['images'][0]);

      print(doc);

      final futureBytes =
          _storage.getFileView(bucketId: announcementsBucketId, fileId: id);

      newAnnounces
          .add(Announcement.fromJson(json: doc, futureBytes: futureBytes));
    }

    return newAnnounces;
  }

  Future<List<Announcement>> searchLimitAnnouncements(
      String? lastId, String? searchText, String? sortBy,
      {double? minPrice, double? maxPrice}) async {
    //print(jsonEncode({'lastID': lastId, 'searchText': searchText}));

    Map<String, dynamic> requestData = {};

    if ((lastId ?? "").isEmpty) lastId = null;

    if (lastId != null) requestData['lastID'] = lastId;
    if (searchText != null && searchText.isNotEmpty) {
      requestData['searchText'] = searchText;
    }
    if (sortBy != null) requestData['sortBy'] = sortBy;
    if (minPrice != null) requestData['minPrice'] = minPrice;
    if (maxPrice != null) requestData['maxPrice'] = maxPrice;

    //print(requestData);

    final res = await _functions.createExecution(
        functionId: getAnnouncementFunctionID, data: jsonEncode(requestData));

    return _announcementsFromRes(res.response);
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

  Future<void> likePost(
      {required String postId, required String userId}) async {
    final docs = await _databases.listDocuments(
        databaseId: postDatabase,
        collectionId: likesCollection,
        queries: [
          Query.equal('user_id', userId),
          Query.equal('anounce_id', postId)
        ]);

    if (docs.documents.isNotEmpty) return;

    await _databases.createDocument(
        databaseId: postDatabase,
        collectionId: likesCollection,
        documentId: ID.unique(),
        permissions: [
          Permission.delete(Role.user(userId)),
          Permission.read(Role.user(userId))
        ],
        data: {
          "user_id": userId,
          "anounce_id": postId
        });
  }

  List<Announcement> _announcementsFromRes(String response) {
    final res = jsonDecode(response);

    List<Announcement> newAnnounces = [];
    for (var doc in res[responseDocuments]) {
      print(doc);

      final id = _getIdFromUrl(doc['images'][0]);

      final futureBytes =
          _storage.getFileView(bucketId: announcementsBucketId, fileId: id);

      newAnnounces
          .add(Announcement.fromJson(json: doc, futureBytes: futureBytes));
    }

    return newAnnounces;
  }

  Future<void> unlikePost(
      {required String postId, required String userId}) async {
    final docs = await _databases.listDocuments(
        databaseId: postDatabase,
        collectionId: likesCollection,
        queries: [
          Query.equal('user_id', userId),
          Query.equal('anounce_id', postId)
        ]);


    final doc = docs.documents[0];

    await _databases.deleteDocument(
        databaseId: postDatabase,
        collectionId: likesCollection,
        documentId: doc.$id);
  }

  Future getFavouritesAnnouncements(
      {String? lastId, required String userId}) async {
    final account = Account(_client);
    final jwt = await account.createJWT();

    final res = await _functions.createExecution(
        functionId: '64fc602a06b438e9870a', data: jsonEncode({'jwt': jwt.jwt}));

    List<Announcement> announcements = _announcementsFromRes(res.response);

    for (int i = 0; i < announcements.length; i++) {
      announcements[i].liked = true;
    }

    return announcements;
  }

  Future getUserAnnouncements({required String userId}) async {
    final res = await _databases.listDocuments(
        databaseId: postDatabase,
        collectionId: postCollection,
        queries: [Query.equal("creator_id", userId), Query.orderDesc('\$createdAt')]);

    List<Announcement> announcements = [];
    for (var doc in res.documents) {
      print(doc.data);

      final id = _getIdFromUrl(doc.data['images'][0]);

      final futureBytes =
          _storage.getFileView(bucketId: announcementsBucketId, fileId: id);

      announcements
          .add(Announcement.fromJson(json: doc.data, futureBytes: futureBytes));
    }

    return announcements;
  }

  Future changeActivityAnnouncements(String announcementsId) async {
    final res = await _databases.getDocument(
        databaseId: postDatabase,
        collectionId: postCollection,
        documentId: announcementsId);
    final bool currentValue = res.data['active'];

    await _databases.updateDocument(
        databaseId: postDatabase,
        collectionId: postCollection,
        documentId: announcementsId,
        data: {'active': !currentValue});
  }

  Future<Announcement> getAnnouncementById(String announcementId) async {
    final res = await _databases.getDocument(
        databaseId: postDatabase,
        collectionId: postCollection,
        documentId: announcementId);

    final id = _getIdFromUrl(res.data['images'][0]);

    final futureBytes =
        _storage.getFileView(bucketId: announcementsBucketId, fileId: id);

    return Announcement.fromJson(json: res.data, futureBytes: futureBytes);
  }
}
