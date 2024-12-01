part of '../database_service.dart';

class BlockedUsersService {
  final Databases _databases;

  BlockedUsersService(Databases databases) : _databases = databases;

  Future<bool> checkBlock({
    required String authorId,
    required String blockedUserId,
  }) async {
    List<String> queries = [];
    queries.add(Query.equal('authorId', authorId));
    queries.add(Query.equal('blockedUserId', blockedUserId));
    queries.add(Query.limit(1));

    final res = await _databases.listDocuments(
      databaseId: mainDatabase,
      collectionId: blockedUsersCollection,
      queries: queries,
    );

    return res.documents.isNotEmpty;
  }

  Future<List<BlockedUser>> getBlockedUsers(String blockedUserId) async {
    List<String> queries = [];
    queries.add(Query.equal('blockedUserId', blockedUserId));

    final res = await _databases.listDocuments(
      databaseId: mainDatabase,
      collectionId: blockedUsersCollection,
      queries: queries,
    );

    List<BlockedUser> result = [];
    for (var doc in res.documents) {
      result.add(BlockedUser.fromJson(doc.data));
    }

    return result;
  }

  Future<String?> addBlock({
    required String authorId,
    required String blockedUserId,
  }) async {
    final data = <String, dynamic>{
      'authorId': authorId,
      'blockedUserId': blockedUserId,
    };

    try {
      await _databases.createDocument(
        databaseId: mainDatabase,
        collectionId: blockedUsersCollection,
        documentId: ID.unique(),
        data: data,
        permissions: [
          Permission.read(Role.user(authorId)),
          Permission.delete(Role.user(authorId)),
        ],
      );
    } catch (err) {
      return Future.value(err.toString());
    }

    return Future.value(null);
  }

  Future<String?> removeBlock({
    required String authorId,
    required String blockedUserId,
  }) async {
    List<String> queries = [];
    queries.add(Query.equal('authorId', authorId));
    queries.add(Query.equal('blockedUserId', blockedUserId));

    try {
      final res = await _databases.listDocuments(
        databaseId: mainDatabase,
        collectionId: blockedUsersCollection,
        queries: queries,
      );

      for (var doc in res.documents) {
        await _databases.deleteDocument(
          databaseId: mainDatabase,
          collectionId: blockedUsersCollection,
          documentId: doc.$id,
        );
      }
    } catch (err) {
      return Future.value(err.toString());
    }

    return Future.value(null);
  }
}
