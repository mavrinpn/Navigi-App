part of '../database_service.dart';

class MessagesService {
  final Databases _databases;
  final Realtime _realtime;
  final Functions _functions;
  final Storage _storage;

  final UserService _usersService;

  MessagesService(Databases databases, Realtime realtime, Functions functions,
      Storage storage, UserService userService)
      : _databases = databases,
        _storage = storage,
        _functions = functions,
        _usersService = userService,
        _realtime = realtime;

  RealtimeSubscription getMessagesSubscription() => _realtime.subscribe(
      ['databases.$mainDatabase.collections.$messagesCollection.documents']);

  ChatUserInfo _getOtherUserNameAndImage(
      Map<String, dynamic> documentData, String userId) {
    final user1 = documentData['user1'];
    final user2 = documentData['user2'];
    // print(user1);
    // print(user2);

    if (user1[DefaultDocumentParameters.id] != userId) {
      return ChatUserInfo.fromJson(user1);
    } else {
      return ChatUserInfo.fromJson(user2);
    }
  }

  Future<bool> _onlineGetter(String userId) async {
    final dt = await _usersService.getLastUserOnline(userId);

    final now = DateTime.now();
    return now.difference(dt).inSeconds < 40;
  }

  Room _roomFromDoc(Document doc, String userId) {
    final otherUser = _getOtherUserNameAndImage(doc.data, userId);

    Future<Uint8List> futureBytes;
    if (doc.data['announcement'] != null &&
        doc.data['announcement']['images'] != null) {
      final id = getIdFromUrl(doc.data['announcement']['images'][0]);

      futureBytes =
          _storage.getFileView(bucketId: announcementsBucketId, fileId: id);
    } else {
      futureBytes = Future.value(Uint8List.fromList([]));
    }

    return Room.fromDocument(
      doc,
      futureBytes,
      otherUser,
      onlineGetter: _onlineGetter,
    );
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
      final message = Message.fromDocument(doc, userId);
      messages.add(message);
    }

    return messages;
  }

  Future<void> refreshOnlineStatus(String userId) async {
    final time = DateTime.now().toIso8601String();
    _databases.updateDocument(
        databaseId: mainDatabase,
        collectionId: usersCollection,
        documentId: userId,
        data: {'lastSeen': time});
  }

  Future<DateTime?> userLastSeen(String userId) async {
    final res = await _databases.getDocument(
        databaseId: mainDatabase,
        collectionId: usersCollection,
        documentId: userId);
    return DateTime.tryParse(res.data['lastSeen']);
  }

  Future<void> markMessagesAsRead(String chatId, String userId) async {
    final docs = await _databases.listDocuments(
      databaseId: mainDatabase,
      collectionId: messagesCollection,
      queries: [
        Query.equal('roomId', chatId),
        Query.notEqual('creatorId', userId),
        Query.isNull('wasRead'),
      ],
    );

    for (var doc in docs.documents) {
      if (doc.data['wasRead'] == null) {
        final data = {'wasRead': DateTime.now().millisecondsSinceEpoch};

        _databases.updateDocument(
          databaseId: mainDatabase,
          collectionId: messagesCollection,
          documentId: doc.$id,
          data: data,
        );
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
    final encodedBody = jsonEncode({
      'roomId': roomId,
      'senderId': senderId,
      'message': content,
      'images': images ?? []
    });

    try {
      //TODO send message
      final res = await _functions.createExecution(
        functionId: '657f16bf26ccb6ca8093',
        body: encodedBody,
      );

      if (res.responseStatusCode == 500) {
        throw Exception('Error: ${res.responseStatusCode}');
      }
    } catch (err) {
      throw Exception(err.toString());
    }

    // print('errors: ${res.errors}');
    // print('body: ${res.responseBody}');
    // print('headers: ${res.requestHeaders}');
    // print('status code: ${res.responseStatusCode}');
    // print('logs: ${res.logs}');
  }
}
