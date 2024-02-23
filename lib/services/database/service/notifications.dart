part of '../database_service.dart';

class NotificationsDatabaseService {
  final Databases _databases;

  static const String collection = 'pushTokens';

  NotificationsDatabaseService(Databases databases) : _databases = databases;

  Future<void> createNotificationToken(String userId, String token) =>
      _databases.createDocument(
          databaseId: mainDatabase,
          collectionId: collection,
          documentId: userId,
          data: {
            'user': userId,
            'token': token,
          });

  Future<void> updateNotificationToken(String userId, String token) =>
      _databases.updateDocument(
          databaseId: mainDatabase,
          collectionId: collection,
          documentId: userId,
          data: {'token': token});

  Future<bool> userExists(String userId) async {
    try {
      await _databases.getDocument(
          databaseId: mainDatabase,
          collectionId: collection,
          documentId: userId);
      return true;
    } catch (e) {
      return false;
    }
  }
}
