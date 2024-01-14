part of '../database_service.dart';

class MessagesService {
  final Databases _databases;
  final Realtime _realtime;
  final Functions _functions;
  final Storage _storage;

  MessagesService(Databases databases, Realtime realtime, Functions functions,
      Storage storage)
      : _databases = databases,
        _storage = storage,
        _functions = functions,
        _realtime = realtime;

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

    final id = getIdFromUrl(data['announcement']['images'][0]);

    final futureBytes =
        _storage.getFileView(bucketId: announcementsBucketId, fileId: id);

    return Room(
        announcement: Announcement.fromJson(
            json: data['announcement'], futureBytes: futureBytes),
        chatName: '${otherUser['name']} $announcementName',
        otherUserId: otherUser['id']!,
        otherUserAvatarUrl: otherUser['image'],
        otherUserName: otherUser['name']!,
        id: doc.$id);
  }

  Future<List<Room>> getUserChats(String userId) async {
    final res = await _databases.listDocuments(
        databaseId: mainDatabase,
        collectionId: roomsCollection,
        queries: [Query.search('members', userId)]);
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

  Future<List<Message>> getChatMessages(String chatId, String userId,
      {int? limit}) async {
    final queries = [Query.equal('roomId', chatId)];
    if (limit != null) {
      queries.add(Query.limit(limit));
      if (limit == 1) {
        queries.add(Query.orderDesc(DefaultDocumentParameters.createdAt));
      }
    }

    final res = await _databases.listDocuments(
      databaseId: mainDatabase,
      collectionId: messagesCollection,
      queries: queries,
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
      if (doc.data['wasRead'] != null) {
        message.wasRead =
            DateTime.fromMillisecondsSinceEpoch(doc.data['wasRead']);
      }

      messages.add(message);
    }

    return messages;
  }

  Future<void> markMessagesAsRead(String chatId, String userId) async {
    final docs = await _databases.listDocuments(
        databaseId: mainDatabase,
        collectionId: messagesCollection,
        queries: [
          Query.equal('roomId', chatId),
          Query.notEqual('creatorId', userId),
          Query.isNull('wasRead')
        ]);
    for (var doc in docs.documents) {
      if (doc.data['wasRead'] == null) {
        _databases.updateDocument(
            databaseId: mainDatabase,
            collectionId: messagesCollection,
            documentId: doc.$id,
            data: {'wasRead': DateTime.now().millisecondsSinceEpoch});
      }
    }
  }

  Future<void> markMessageAsRead(String messageId) async {
    _databases.updateDocument(
        databaseId: mainDatabase,
        collectionId: messagesCollection,
        documentId: messageId,
        data: {'wasRead': DateTime.now().millisecondsSinceEpoch});
  }

  Future<Map<String, dynamic>> createRoom(
      List<String> userIds, String announcementId) async {
    final room = await _databases.createDocument(
      databaseId: mainDatabase,
      collectionId: roomsCollection,
      documentId: ID.unique(),
      data: {
        'user1': userIds[0],
        'user2': userIds[1],
        'members': userIds,
        'announcement': announcementId,
      },
    );

    return {'room': room.$id};
  }

  Future<void> sendMessage(
      {required String roomId,
      required String content,
      required String senderId,
      List<String>? images}) async {
    final encodedBody = jsonEncode(
        {'roomId': roomId, 'senderId': senderId, 'message': content});
    final res = await _functions.createExecution(
        functionId: '657f16bf26ccb6ca8093', body: encodedBody);
  }
}
