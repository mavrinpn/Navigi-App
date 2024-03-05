part of '../database_service.dart';

class FavouritesService {
  final Databases _databases;
  final Storage _storage;

  FavouritesService(Databases databases, Storage storage)
      : _databases = databases,
        _storage = storage;

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

  Future getFavouritesAnnouncements({
    String? lastId,
    required String userId,
  }) async {
    final documents = await _databases.listDocuments(
      databaseId: mainDatabase,
      collectionId: likesCollection,
      queries: [Query.equal('user_id', userId)],
    );

    List<Announcement> announcements = [];

    for (var doc in documents.documents) {
      Future<Uint8List> futureBytes;
      if (doc.data['postCollection'] != null &&
          doc.data['postCollection']['images'] != null) {
        final id = getIdFromUrl(doc.data['postCollection']['images'][0]);

        futureBytes =
            _storage.getFileView(bucketId: announcementsBucketId, fileId: id);
      } else {
        futureBytes = Future.value(Uint8List.fromList([]));
      }
      if (doc.data['postCollection'] != null) {
        final announcement = Announcement.fromJson(
            json: doc.data['postCollection'], futureBytes: futureBytes);
        announcements.add(announcement);
      }
    }
    for (int i = 0; i < announcements.length; i++) {
      announcements[i].liked = true;
    }
    return announcements;
  }
}
