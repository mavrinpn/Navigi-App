part of '../database_service.dart';

class NotificationsDatabaseService {
  final Databases _databases;

  static const String pushTokensCollection = 'pushTokens';

  NotificationsDatabaseService(Databases databases) : _databases = databases;

  Future<void> createNotificationToken(String userId, String token) {
    return _databases.createDocument(
      databaseId: mainDatabase,
      collectionId: pushTokensCollection,
      documentId: userId,
      data: {
        'user': userId,
        'token': token,
      },
      permissions: [
        Permission.read(Role.user(userId)),
        Permission.delete(Role.user(userId)),
      ],
    );
  }

  Future<void> updateNotificationToken(String userId, String token) {
    return _databases.updateDocument(
      databaseId: mainDatabase,
      collectionId: pushTokensCollection,
      documentId: userId,
      data: {
        'user': userId,
        'token': token,
      },
    );
  }

  Future<bool> userExists(String userId) async {
    try {
      await _databases.getDocument(databaseId: mainDatabase, collectionId: pushTokensCollection, documentId: userId);
      return true;
    } catch (e) {
      return false;
    }
  }
}
