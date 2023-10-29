import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:rxdart/rxdart.dart';
import 'package:smart/models/messenger/chat_preview.dart';
import 'package:smart/models/messenger/message.dart';
import 'package:smart/services/database_service.dart';

class MessengerRepository {
  final DatabaseService databaseService;
  RealtimeSubscription? _listenCurrentChat;

  MessengerRepository({required this.databaseService}) :
      _listenCurrentChat = databaseService.getMessagesSubscription();

  List<BehaviorSubject<ChatPreview>> chats = [];
  BehaviorSubject<List<Message>> currentChatMessages = BehaviorSubject.seeded([]);

  void preloadChats() async {

  }
}