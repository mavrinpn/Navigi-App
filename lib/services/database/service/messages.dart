part of '../database_service.dart';

class MessagesService {
  final Databases _databases;
  final Realtime _realtime;
  final Functions _functions;
  // final Storage _storage;
  final Account _account;

  final UserService _usersService;

  final sendMessageFunc = '657f16bf26ccb6ca8093';
  final readMessageFunc = '6746467a6f3f51b5b370';

  MessagesService(
    Databases databases,
    Realtime realtime,
    Functions functions,
    Storage storage,
    UserService userService,
    Account account,
  )   : _databases = databases,
        // _storage = storage,
        _account = account,
        _functions = functions,
        _usersService = userService,
        _realtime = realtime;

  RealtimeSubscription getMessagesSubscription() {
    return _realtime.subscribe(['databases.$mainDatabase.collections.$messagesCollection.documents']);
  }

  ChatUserInfo _getOtherUserNameAndImage(Map<String, dynamic> documentData, String userId) {
    final user1 = documentData['announcement']['creator'];
    final user2 = documentData['otherUser'];

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

    return Room.fromDocument(
      doc,
      otherUser,
      userId,
      onlineGetter: _onlineGetter,
    );
  }

  Future<List<Room>> getUserChats(String userId) async {
    final res = await _databases.listDocuments(
      databaseId: mainDatabase,
      collectionId: roomsCollection,
      queries: [
        Query.contains('members', userId),
        Query.limit(1000),
      ],
    );
    List<Room> chats = [];
    for (var doc in res.documents) {
      if (doc.data['announcement'] != null) {
        chats.add(_roomFromDoc(doc, userId));
      }
    }
    return chats;
  }

  Future<Room> getRoom(String id, String userId) async {
    final doc = await _databases.getDocument(
      databaseId: mainDatabase,
      collectionId: roomsCollection,
      documentId: id,
    );

    return _roomFromDoc(doc, userId);
  }

  Future<List<Message>> getChatMessages(String chatId, String userId, {int? limit}) async {
    final queries = [Query.equal('roomId', chatId)];
    if (limit != null) {
      queries.add(Query.limit(limit));
      if (limit == 1) {
        queries.add(Query.orderDesc(DefaultDocumentParameters.createdAt));
      }
    } else {
      queries.add(Query.limit(1000));
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
      data: {
        'lastSeen': time,
      },
    );
  }

  Future<DateTime?> userLastSeen(String userId) async {
    final res =
        await _databases.getDocument(databaseId: mainDatabase, collectionId: usersCollection, documentId: userId);
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
        await markMessageAsRead(doc.$id);
      }
    }
  }

  Future<void> markMessageAsRead(String messageId) async {
    final encodedBody = jsonEncode({
      'messageID': messageId,
    });
    try {
      final res = await _functions.createExecution(
        functionId: readMessageFunc,
        body: encodedBody,
      );
      debugPrint(res.responseBody);
    } catch (err) {
      debugPrint(err.toString());
    }
    // _databases.updateDocument(
    //   databaseId: mainDatabase,
    //   collectionId: messagesCollection,
    //   documentId: messageId,
    //   data: {'wasRead': DateTime.now().millisecondsSinceEpoch},
    // );
  }

  // Future<String> createRoomDirect(
  //   // String userId,
  //   String announcementUserId,
  //   String announcementId,
  // ) async {
  //   final myUserId = (await _account.get()).$id;
  //   final existRoom = await _databases.listDocuments(
  //     databaseId: mainDatabase,
  //     collectionId: roomsCollection,
  //     queries: [
  //       Query.equal('otherUser', myUserId),
  //       Query.equal('announcement', announcementId),
  //     ],
  //   );

  //   if (existRoom.documents.isNotEmpty) {
  //     return existRoom.documents.first.$id;
  //   }

  //   final room = await _databases.createDocument(
  //     databaseId: mainDatabase,
  //     collectionId: roomsCollection,
  //     documentId: ID.unique(),
  //     data: {
  //       'otherUser': myUserId,
  //       'members': [announcementUserId, myUserId],
  //       'announcement': announcementId,
  //     },
  //   );

  //   return room.$id;
  // }

  Future<String> createRoomByFunc(
    String otherUserId,
    String announcementId,
  ) async {
    final existRoom = await _databases.listDocuments(
      databaseId: mainDatabase,
      collectionId: roomsCollection,
      queries: [
        Query.equal('otherUser', otherUserId),
        Query.equal('announcement', announcementId),
      ],
    );

    if (existRoom.documents.isNotEmpty) {
      return existRoom.documents.first.$id;
    }

    final jwt = await getJwt();
    final encodedBody = jsonEncode({
      'jwt': jwt,
      'announcement': announcementId,
      'receiverId': otherUserId,
    });

    try {
      final res = await _functions.createExecution(
        functionId: sendMessageFunc,
        body: encodedBody,
      );

      final resBody = jsonDecode(res.responseBody);

      return resBody['room_id'] != null ? resBody['room_id'] as String : '';
    } catch (err) {
      // ignore: avoid_print
      print(err);
      return '';
    }
  }

  Future<String> getJwt() {
    return _account.createJWT().then((value) => value.jwt);
  }

  Future<void> sendMessageByFunc({
    required Room room,
    required String roomId,
    required String content,
    required String senderId,
    List<String>? images,
  }) async {
    final jwt = await getJwt();

    final encodedBody = jsonEncode({
      'jwt': jwt,
      'roomId': roomId,
      'message': content,
      'images': images ?? [],
    });

    try {
      final res = await _functions.createExecution(
        functionId: sendMessageFunc,
        body: encodedBody,
      );

      debugPrint(res.responseBody);
      debugPrint('${res.responseStatusCode}');
      if (res.responseStatusCode == 500) {
        // throw Exception('Error: ${res.responseStatusCode}');
      }
    } catch (err) {
      debugPrint(err.toString());
      // throw Exception(err.toString());
    }
  }
}
