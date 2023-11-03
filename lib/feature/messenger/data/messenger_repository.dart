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

  MessengerRepository({required this.databaseService})
      : _messageListener = databaseService.getMessagesSubscription();

  List<Room> _chats = [];
  BehaviorSubject<List<Room>> chats = BehaviorSubject.seeded([]);
  BehaviorSubject<List<Message>> currentChatMessages =
      BehaviorSubject.seeded([]);

  void selectChat(String id, Message lastMessage) async {
    currentChatId = id;
    currentChatMessages.add([lastMessage]);
  }

  String? currentChatId;

  void preloadChats() async {
    _chats = await databaseService.getUserChats(userId!);
    chats.add(_chats);

    _messageListener?.stream.listen((event) {
      print(event.payload);
    });
  }

  void loadChatsMessages() async {
    for (int i = 0; i < _chats.length; i++) {
      final chat = _chats[i];
      final messages = await databaseService.getChatMessages(chat.id, userId!);
      if (messages.isNotEmpty) {
        _chats[i].lastMessage = messages.first;
      }
    }
    chats.add(_chats);
  }

  int? findChatById(String id) {
    for (int i = 0; i < _chats.length; i++) {
      if (_chats[i].id == id) {
        return i;
      }
    }
    return null;
  }

  void loadChatMessages(String id) async {
    final messages = await databaseService.getChatMessages(id, userId!);
    if (messages.isNotEmpty) {
      currentChatMessages.add(messages);
    }
  }
}
