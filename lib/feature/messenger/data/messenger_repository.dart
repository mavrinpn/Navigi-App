import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:rxdart/rxdart.dart';
import 'package:smart/models/messenger/chat_preview.dart';
import 'package:smart/models/messenger/message.dart';
import 'package:smart/services/database_service.dart';

class MessengerRepository {
  final DatabaseService databaseService;
  RealtimeSubscription? _messageListener;

  String? userId;

  MessengerRepository({required this.databaseService}) :
        _messageListener = databaseService.getMessagesSubscription();

  List<ChatPreview> _chats = [];
  BehaviorSubject<List<ChatPreview>> chats = BehaviorSubject.seeded([]);
  BehaviorSubject<List<Message>> currentChatMessages = BehaviorSubject.seeded([]);

  void preloadChats() async {
    _chats = await databaseService.getUserChats(userId!);
    chats.add(_chats);
  }

  void loadChatsMessages() async {
    for (var chat in _chats) {

    }
  }
}