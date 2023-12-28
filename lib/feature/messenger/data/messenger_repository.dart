import 'dart:async';
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:rxdart/rxdart.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/models/messenger/chat_item.dart';
import 'package:smart/models/messenger/room.dart';
import 'package:smart/models/messenger/date_splitter.dart';
import 'package:smart/models/messenger/message.dart';
import 'package:smart/models/messenger/messages_group.dart';
import 'package:smart/services/database_service.dart';

class MessengerRepository {
  static const String _needCreateRoomId = 'NEED_CREATE_ROOM';

  final DatabaseService _databaseService;
  RealtimeSubscription? _messageListener;

  MessengerRepository({required DatabaseService databaseService})
      : _databaseService = databaseService;

  String? _userId;
  List<Room> _chats = [];
  List<Message> _currentChatMessages = [];
  StreamSubscription? _listener;

  set userId(String newUserId) => _userId = newUserId;

  BehaviorSubject<List<Room>> chatsStream = BehaviorSubject.seeded([]);
  BehaviorSubject<List<ChatItem>> currentChatItemsStream =
      BehaviorSubject.seeded([]);

  Room? currentRoom;

  void closeChat() {
    currentRoom = null;
    _currentChatMessages = [];
    currentChatItemsStream.add([]);
  }

  void clear() {
    _userId = null;
    _currentChatMessages.clear();
    _chats.clear();

    chatsStream.add(_chats);
    currentChatItemsStream.add([]);

    _listener?.cancel();
  }

  void selectChat({String? id, Announcement? announcement}) async {
    assert(id != null || announcement != null, 'Что-то одно должно быть');
    if (id != null) {
      _selectRoomById(id);
      _markAllMessagesAsRead();
    } else {
      _selectRoomByAnnouncement(announcement!);
    }
  }

  void preloadChats() async {
    _chats = await _databaseService.getUserChats(_userId!);
    chatsStream.add(_chats);
    _loadChatsMessages();
    // refreshSubscription();
  }

  Future<void> sendMessage(String content) async {
    if (currentRoom?.id == _needCreateRoomId) await _createRoom();

    await _databaseService.sendMessage(
      roomId: currentRoom!.id,
      content: content,
      senderId: _userId!,
    );
    print('message sended');

  }

  void searchChat(String query) {
    final list = <Room>[];

    for (Room i in _chats) {
      if (i.chatName.contains(query)) {
        list.add(i);
      }
    }

    chatsStream.add(list);
  }

  int notificationsAmount() {
    int c = 0;
    for (var i in _chats) {
      if (i.lastMessage == null) continue;
      if (i.lastMessage?.wasRead == null && !i.lastMessage!.owned) c++;
    }

    return c;
  }

  void refreshSubscription() async {
    _listener?.cancel();
    _messageListener?.close();
    _messageListener = _databaseService.getMessagesSubscription();
    _listener = _messageListener?.stream.listen(_listenMessages);
    log('subscription refreshed');
  }

  // -------------------------------------------------------------

  Future<void> _createRoom() async {
    final roomData = await _databaseService.createRoom(
        [_userId!, currentRoom!.announcement.creatorData.uid],
        currentRoom!.announcement.id);

    currentRoom = await _databaseService.getRoom(roomData['room'], _userId!);
    _chats.add(currentRoom!);
    chatsStream.add(_chats);
    // refreshSubscription();
  }

  void _selectRoomById(String id) {
    final Message? lastMessage = _chats[_findChatById(id)!].lastMessage;
    currentRoom = _chats[_findChatById(id)!];
    _currentChatMessages = lastMessage != null ? [lastMessage] : [];
    currentChatItemsStream.add(lastMessage != null
        ? [
            MessagesGroup(messages: [lastMessage])
          ]
        : []);
    _loadChatMessages(id);
  }

  void _selectRoomByAnnouncement(Announcement announcement) {
    for (Room room in _chats) {
      if (room.announcement.id == announcement.id) {
        return _selectRoomById(room.id);
      }
    }

    currentRoom = Room(
        id: _needCreateRoomId,
        chatName: '',
        otherUserId: announcement.creatorData.uid,
        otherUserName: announcement.creatorData.name,
        otherUserAvatarUrl: announcement.creatorData.imageUrl,
        announcement: announcement);

    _currentChatMessages.clear();
    currentChatItemsStream.add(_sortMessagesByDate(_currentChatMessages));
  }

  _upChannelFrom(int index) {
    final chat = _chats.removeAt(index);
    _chats.insert(0, chat);
  }

  void _loadChatsMessages() async {
    for (int i = 0; i < _chats.length; i++) {
      final chat = _chats[i];
      final messages =
          await _databaseService.getChatMessages(chat.id, _userId!);
      if (messages.isNotEmpty) {
        _chats[i].lastMessage = messages.last;
        if (messages.last.wasRead == null && !messages.last.owned) {
          _upChannelFrom(i);
        }
      }
    }
    chatsStream.add(_chats);
  }

  int? _findChatById(String id) {
    for (int i = 0; i < _chats.length; i++) {
      if (_chats[i].id == id) {
        return i;
      }
    }
    return null;
  }

  void _loadChatMessages(String id) async {
    final messages = await _databaseService.getChatMessages(id, _userId!);
    if (messages.isNotEmpty) {
      _currentChatMessages = messages;
      currentChatItemsStream.add(_sortMessagesByDate(_currentChatMessages));
    }
  }

  List<ChatItem> _sortMessagesByDate(List<Message> messages) {
    if (messages.isEmpty) return [];

    final List<ChatItem> items = [];
    items.add(DateSplitter(dateTime: messages.first.createdAtDt));

    for (Message message in messages) {
      if (items.last is DateSplitter) {
        items.add(MessagesGroup(messages: [message]));
      } else {
        final lastGroup = items.last as MessagesGroup;
        bool timeConditionToSplitGroups =
            (lastGroup.sentAt.difference(message.createdAtDt).inSeconds).abs() >
                30;
        if (lastGroup.owned != message.owned || timeConditionToSplitGroups) {
          if (lastGroup.diffDate(message.createdAtDt)) {
            items.add(DateSplitter(dateTime: message.createdAtDt));
          }

          items.add(MessagesGroup(messages: [message]));
        } else {
          (items.last as MessagesGroup).addMessage(message);
        }
      }
    }

    return items.reversed.toList();
  }

  void _listenMessages(RealtimeMessage event) async {
    log(event.payload.toString());

    if (event.events.contains('databases.*.collections.*.documents.*.create')) {
      _handleCreating(event);
    }
    if (event.events.contains('databases.*.collections.*.documents.*.update')) {
      _handleUpdates(event);
    }
  }

  void _handleCreating(RealtimeMessage event) async {
    log(event.payload.toString());

    event.events.forEach((element) {
      print(element);
    });

    final data = event.payload;

    final message = Message.fromJson(data, _userId!);

    if (data['roomId'] == currentRoom?.id) {
      _addMessageToCurrentRoom(data, message);
    }

    final index = _findChatById(data['roomId']);

    index != null ? _changeLastMessage(index, message) : _getNewRoom(data);
  }

  void _handleUpdates(RealtimeMessage event) async {
    final data = event.payload;

    if (data['roomId'] == currentRoom?.id) {
      _updateMessageInCurrentRoom(data);
    }

    _updateRoomsPreviewMessages(data);
  }

  void _markAllMessagesAsRead() =>
      _databaseService.markMessagesAsRead(currentRoom!.id, _userId!);

  void _addMessageToCurrentRoom(data, Message message) {
    _currentChatMessages.add(message);
    currentChatItemsStream.add(_sortMessagesByDate(_currentChatMessages));
    if (message.senderId != _userId) {
      _databaseService.markMessageAsRead(data['\$id']);
    }
  }

  void _getNewRoom(data) async {
    final room = await _databaseService.getRoom(data['roomId'], _userId!);
    final messages = await _databaseService.getChatMessages(room.id, _userId!);
    room.lastMessage = messages[0];
    _chats.add(room);
    chatsStream.add(_chats);
  }

  void _changeLastMessage(int index, Message message) {
    _chats[index].lastMessage = message;

    _upChannelFrom(index);
    chatsStream.add(_chats);
  }

  _updateMessageInCurrentRoom(Map<String, dynamic> messageData) {
    for (int i = 0; i < _currentChatMessages.length; i++) {
      if (_currentChatMessages[i].id == messageData['\$id']) {
        _currentChatMessages[i] = Message.fromJson(messageData, _userId!);
        currentChatItemsStream.add(_sortMessagesByDate(_currentChatMessages));
      }
    }
  }

  _updateRoomsPreviewMessages(Map<String, dynamic> data) {
    for (int i = 0; i < _chats.length; i++) {
      if (_chats[i].lastMessage?.id == data['\$id']) {
        _changeLastMessage(i, Message.fromJson(data, _userId!));
      }
    }
  }
}
