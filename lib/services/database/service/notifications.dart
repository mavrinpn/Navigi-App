part of '../database_service.dart';

class NotificationsDatabaseService {
  final Databases _databases;

  NotificationsDatabaseService(Databases databases) : _databases = databases;

  Future<void> refreshNotificationToken(String userId, String token) =>
      _databases.createDocument(
          databaseId: mainDatabase,
          collectionId: 'pushTokens',
          documentId: userId,
          data: {
            'user': userId,
            'token': token,
          });
}
