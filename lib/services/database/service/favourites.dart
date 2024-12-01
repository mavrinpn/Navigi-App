part of '../database_service.dart';

class FavouritesService {
  final Databases _databases;
  final Functions _functions;

  FavouritesService(
    Databases databases,
    Storage storage,
    Functions functions,
  )   : _databases = databases,
        _functions = functions;

  static const updateStatFunc = '67464802debf6fa7ccca';

  Future<void> likePost({
    required String postId,
    required String userId,
  }) async {
    final docs = await _databases.listDocuments(
        databaseId: mainDatabase,
        collectionId: likesCollection,
        queries: [Query.equal('user_id', userId), Query.equal('postCollection', postId)]);

    if (docs.documents.isNotEmpty) return;

    await _databases.createDocument(
      databaseId: mainDatabase,
      collectionId: likesCollection,
      documentId: ID.unique(),
      data: {
        'user_id': userId,
        'postCollection': postId,
      },
      permissions: [
        Permission.read(Role.user(userId)),
        Permission.delete(Role.user(userId)),
      ],
    );

    final encodedBody = jsonEncode({
      'announcementID': postId,
      'type': 'like',
    });

    try {
      final res = await _functions.createExecution(
        functionId: updateStatFunc,
        body: encodedBody,
      );

      debugPrint(res.responseBody);
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  Future<void> unlikePost({required String postId, required String userId}) async {
    final docs = await _databases.listDocuments(
        databaseId: mainDatabase,
        collectionId: likesCollection,
        queries: [Query.equal('user_id', userId), Query.equal('postCollection', postId)]);

    final doc = docs.documents[0];

    await _databases.deleteDocument(databaseId: mainDatabase, collectionId: likesCollection, documentId: doc.$id);
  }

  Future getFavouritesAnnouncements({
    String? lastId,
    required String userId,
  }) async {
    final documents = await _databases.listDocuments(
      databaseId: mainDatabase,
      collectionId: likesCollection,
      queries: [
        Query.equal('user_id', userId),
        Query.orderDesc('\$createdAt'),
      ],
    );

    List<Announcement> announcements = [];

    for (var doc in documents.documents) {
      // Future<Uint8List> futureBytes;
      // if (doc.data['postCollection'] != null && doc.data['postCollection']['images'] != null) {
      // final imageUrl = doc.data['postCollection']['images'][0];
      // futureBytes = futureBytesForImageURL(
      //   storage: _storage,
      //   imageUrl: imageUrl,
      // );
      // } else {
      // futureBytes = Future.value(Uint8List.fromList([]));
      // }
      if (doc.data['postCollection'] != null) {
        final announcement = Announcement.fromJson(
          json: doc.data['postCollection'],
          // futureBytes: futureBytes,
          subcollTableId: '',
        );
        announcements.add(announcement);
      }
    }
    for (int i = 0; i < announcements.length; i++) {
      announcements[i].liked = true;
    }
    return announcements;
  }

  Future<int> countLikes({required String postId}) async {
    final docs = await _databases.listDocuments(
        databaseId: mainDatabase, collectionId: likesCollection, queries: [Query.equal('postCollection', postId)]);

    return docs.documents.length;
  }
}
