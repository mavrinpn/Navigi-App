import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:smart/models/messenger/message.dart';
import 'package:smart/models/sorte_types.dart';
import 'package:smart/models/user.dart';

import '../models/announcement.dart';
import '../models/announcement_creating_data.dart';
import '../models/messenger/room.dart';
import '../models/models.dart';
import '../utils/constants.dart';

class DefaultDocumentParameters {
  static const String createdAt = '\$createdAt';
  static const String id = '\$id';
}

const String categoryId = 'categoryId';
const String subcategoryId = 'subcategory';

const String totalViews = 'total_views';

const String userName = 'name';
const String userPhone = 'phone';
const String userImageUrl = 'image_url';

const String _createTeamFunction = '654420cd83b03318d121';

class DatabaseService {
  final Databases _databases;

  final Functions _functions;
  final Storage _storage;
  final Realtime _realtime;
  final Teams _teams;

  DatabaseService({required Client client})
      : _databases = Databases(client),
        _functions = Functions(client),
        _realtime = Realtime(client),
        _storage = Storage(client),
        _teams = Teams(client);

  Future<List<Category>> getAllCategories() async {
    final res = await _databases.listDocuments(
        databaseId: mainDatabase, collectionId: categoriesCollection);

    List<Category> categories = [];
    for (var doc in res.documents) {
      categories.add(Category.fromJson(doc.data));
    }

    return categories;
  }

  Future<List<Subcategory>> getAllSubcategoriesFromCategoryId(
      String categoryID) async {
    List<Subcategory> subcategories = <Subcategory>[];
    final res = await _databases.listDocuments(
        databaseId: mainDatabase,
        collectionId: subcategoriesCollection,
        queries: [Query.equal(categoryId, categoryID)]);

    for (var doc in res.documents) {
      subcategories.add(Subcategory.fromJson(doc.data));
    }
    return subcategories;
  }

  Future<List<SubCategoryItem>> getItemsFromSubcategory(
      String subcategory) async {
    final res = await _databases.listDocuments(
        databaseId: mainDatabase,
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
        databaseId: mainDatabase, collectionId: placeCollection);

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

  Future searchItemsByQuery(String query) async {
    final List<String> queries = [
      Query.search('name', query),
      Query.limit(40),
    ];
    final res = await _databases.listDocuments(
        databaseId: mainDatabase,
        collectionId: itemsCollection,
        queries: queries);
    List<SubCategoryItem> items = [];
    for (var doc in res.documents) {
      items.add(SubCategoryItem.fromJson(doc.data));
    }
    return items;
  }

  Future<List<String>> getPopularQueries() async {
    final res = await _databases.listDocuments(
        databaseId: mainDatabase, collectionId: 'queries');

    return res.documents.map((e) => e.data['name'].toString()).toList();
  }

  Future<List<Announcement>> getAnnouncements(String? lastId) async {
    List<String> queries = [
      Query.orderDesc(DefaultDocumentParameters.createdAt),
      Query.limit(24)
    ];
    if ((lastId ?? '').isEmpty) lastId = null;

    if (lastId != null) queries.add(Query.cursorAfter(lastId));

    final res = await _databases.listDocuments(
        databaseId: mainDatabase,
        collectionId: postCollection,
        queries: queries);

    List<Announcement> newAnnounces =
        _announcementsFromDocuments(res.documents);

    return newAnnounces;
  }

  List<Announcement> _announcementsFromDocuments(List<Document> documents) {
    List<Announcement> newAnnounces = [];
    for (var doc in documents) {
      final id = _getIdFromUrl(doc.data['images'][0]);

      final futureBytes =
          _storage.getFileView(bucketId: announcementsBucketId, fileId: id);

      newAnnounces
          .add(Announcement.fromJson(json: doc.data, futureBytes: futureBytes));
    }

    return newAnnounces;
  }

  Future<List<Announcement>> searchLimitAnnouncements(
      String? lastId, String? searchText, String? sortBy,
      {double? minPrice, double? maxPrice}) async {
    List<String> queries = [];

    if ((lastId ?? "").isEmpty) lastId = null;

    if (lastId != null) queries.add(Query.cursorAfter(lastId));
    if (searchText != null && searchText.isNotEmpty) {
      queries.add(Query.search('name', searchText));
    }
    if (sortBy != null) queries.add(SortTypes.toQuery(sortBy)!);
    if (minPrice != null) {
      queries.add(Query.greaterThanEqual('price', minPrice));
    }
    if (maxPrice != null) queries.add(Query.lessThanEqual('price', maxPrice));

    final res = await _databases.listDocuments(
        databaseId: mainDatabase,
        collectionId: postCollection,
        queries: queries);

    List<Announcement> newAnnounces =
        _announcementsFromDocuments(res.documents);

    return newAnnounces;
  }

  Future<void> incTotalViewsById(String id) async {
    final res = await _databases.getDocument(
        databaseId: mainDatabase, collectionId: postCollection, documentId: id);

    await _databases.updateDocument(
        databaseId: mainDatabase,
        collectionId: postCollection,
        documentId: id,
        data: {totalViews: res.data[totalViews] + 1});
  }

  Future<void> createAnnouncement(String uid, List<String> urls,
      AnnouncementCreatingData creatingData) async {
    await _databases.createDocument(
        databaseId: mainDatabase,
        collectionId: postCollection,
        documentId: ID.unique(),
        data: creatingData.toJson(uid, urls));
  }

  Future<void> createUser(
      {required String name,
      required String uid,
      required String phone}) async {
    await _databases.createDocument(
        databaseId: mainDatabase,
        collectionId: usersCollection,
        documentId: uid,
        data: {userName: name, userPhone: phone});
  }

  Future<UserData> getUserData({required String uid}) async {
    final res = await _databases.getDocument(
        databaseId: mainDatabase,
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
        databaseId: mainDatabase,
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
        databaseId: mainDatabase,
        collectionId: likesCollection,
        queries: [
          Query.equal('user_id', userId),
          Query.equal('postCollection', postId)
        ]);

    if (docs.documents.isNotEmpty) return;

    await _databases.createDocument(
        databaseId: mainDatabase,
        collectionId: likesCollection,
        documentId: ID.unique(),
        permissions: [
          Permission.delete(Role.user(userId)),
          Permission.read(Role.user(userId))
        ],
        data: {
          "user_id": userId,
          "postCollection": postId
        });
  }

  Future<void> unlikePost(
      {required String postId, required String userId}) async {
    final docs = await _databases.listDocuments(
        databaseId: mainDatabase,
        collectionId: likesCollection,
        queries: [
          Query.equal('user_id', userId),
          Query.equal('postCollection', postId)
        ]);

    final doc = docs.documents[0];

    await _databases.deleteDocument(
        databaseId: mainDatabase,
        collectionId: likesCollection,
        documentId: doc.$id);
  }

  Future getFavouritesAnnouncements(
      {String? lastId, required String userId}) async {
    final documents = await _databases.listDocuments(
        databaseId: mainDatabase,
        collectionId: likesCollection,
        queries: [Query.equal('user_id', userId)]);

    List<Announcement> announcements = [];

    for (var doc in documents.documents) {
      final id = _getIdFromUrl(doc.data['postCollection']['images'][0]);

      final futureBytes =
          _storage.getFileView(bucketId: announcementsBucketId, fileId: id);

      announcements.add(Announcement.fromJson(
          json: doc.data['postCollection'], futureBytes: futureBytes));
    }
    for (int i = 0; i < announcements.length; i++) {
      announcements[i].liked = true;
    }
    return announcements;
  }

  Future getUserAnnouncements({required String userId}) async {
    final res = await _databases.listDocuments(
        databaseId: mainDatabase,
        collectionId: postCollection,
        queries: [
          Query.equal("creator_id", userId),
          Query.orderDesc(DefaultDocumentParameters.createdAt)
        ]);

    return _announcementsFromDocuments(res.documents);
  }

  Future changeAnnouncementActivity(String announcementsId) async {
    final res = await _databases.getDocument(
        databaseId: mainDatabase,
        collectionId: postCollection,
        documentId: announcementsId);
    final bool currentValue = res.data['active'];

    await _databases.updateDocument(
        databaseId: mainDatabase,
        collectionId: postCollection,
        documentId: announcementsId,
        data: {'active': !currentValue});
  }

  Future<Announcement> getAnnouncementById(String announcementId) async {
    final res = await _databases.getDocument(
        databaseId: mainDatabase,
        collectionId: postCollection,
        documentId: announcementId);

    final id = _getIdFromUrl(res.data['images'][0]);

    final futureBytes =
        _storage.getFileView(bucketId: announcementsBucketId, fileId: id);

    return Announcement.fromJson(json: res.data, futureBytes: futureBytes);
  }

  RealtimeSubscription getMessagesSubscription() => _realtime.subscribe(
      ['databases.$mainDatabase.collections.$messagesCollection.documents']);

  Map<String, String?> getOtherUserNameAndImage(
      Map<String, dynamic> documentData, String userId) {
    final user1 = documentData['user1'];
    if (user1[DefaultDocumentParameters.id] != userId) {
      return {
        'name': user1['name'],
        'image': user1['image_url'],
        'id': user1['\$id'],
      };
    } else {
      return {
        'name': documentData['user2']['name'],
        'image': documentData['user2']['image_url'],
        'id': documentData['user2']['\$id'],
      };
    }
  }

  Room _roomFromDoc(Document doc, String userId) {
    final data = doc.data;
    final otherUser = getOtherUserNameAndImage(data, userId);
    final String announcementName = data['announcement']['name'];

    final id = _getIdFromUrl(data['announcement']['images'][0]);

    final futureBytes =
        _storage.getFileView(bucketId: announcementsBucketId, fileId: id);

    print('${otherUser['name']} $announcementName');
    return Room(
        announcement: Announcement.fromJson(
            json: data['announcement'], futureBytes: futureBytes),
        teamId: data['team'],
        chatName: '${otherUser['name']} $announcementName',
        otherUserId: otherUser['id']!,
        otherUserAvatarUrl: otherUser['image'],
        id: doc.$id);
  }

  Future<List<Room>> getUserChats(String userId) async {
    final res = await _databases.listDocuments(
      databaseId: mainDatabase,
      collectionId: roomsCollection,
    );
    List<Room> chats = [];
    for (var doc in res.documents) {
      chats.add(_roomFromDoc(doc, userId));
    }
    return chats;
  }

  Future<Room> getRoom(String id, String userId) async {
    final doc = await _databases.getDocument(
        databaseId: mainDatabase,
        collectionId: roomsCollection,
        documentId: id);

    return _roomFromDoc(doc, userId);
  }

  Future<List<Message>> getChatMessages(String chatId, String userId) async {
    final res = await _databases.listDocuments(
      databaseId: mainDatabase,
      collectionId: messagesCollection,
      queries: [Query.equal('roomId', chatId)],
    );

    List<Message> messages = [];
    for (var doc in res.documents) {
      final message = Message(
        id: doc.$id,
        content: doc.data['content'],
        senderId: doc.data['creatorId'],
        images: doc.data['images'],
        owned: userId == doc.data['creatorId'],
        createdAt: doc.$createdAt,
        createdAtDt:
            DateTime.parse(doc.$createdAt).add(DateTime.now().timeZoneOffset),
      );

      messages.add(message);
    }

    return messages;
  }

  Future<Map<String, dynamic>> createRoom(
      List<String> userIds, String announcementId) async {
    final res = await _functions.createExecution(
        functionId: _createTeamFunction,
        body: jsonEncode({
          'user1': userIds[0],
          'user2': userIds[1],
        }));

    final teamId = res.responseBody.replaceAll('"', '');

    final List<String> permissions = [
      Permission.read(Role.team(teamId)),
      Permission.write(Role.team(teamId)),
    ];

    final room = await _databases.createDocument(
        databaseId: mainDatabase,
        collectionId: roomsCollection,
        documentId: ID.unique(),
        data: {
          'team': teamId,
          'user1': userIds[0],
          'user2': userIds[1],
          'members': userIds,
          'announcement': announcementId,
        },
        permissions: permissions);

    return {'room': room.$id, 'team': teamId};
  }

  Future<void> sendMessage(
      {required String roomId,
      required String teamId,
      required String content,
      required String senderId,
      List<String>? images}) async {
    await _databases.createDocument(
        databaseId: mainDatabase,
        collectionId: messagesCollection,
        documentId: ID.unique(),
        data: {
          'room': roomId,
          'roomId': roomId,
          'creatorId': senderId,
          'content': content,
          'images': images ?? []
        },
        permissions: [
          Permission.write(Role.team(teamId)),
          Permission.read(Role.team(teamId)),
        ]);
  }
}
