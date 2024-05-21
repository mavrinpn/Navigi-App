import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:smart/feature/messenger/data/messages_list.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/models/messenger/chat_item.dart';
import 'package:smart/models/messenger/room.dart';
import 'package:smart/models/messenger/message.dart';
import 'package:smart/models/messenger/messages_group.dart';
import 'package:smart/services/database/database_service.dart';
import 'package:smart/services/storage_service.dart';

class MessengerRepository {
  static const String _needCreateRoomId = 'NEED_CREATE_ROOM';

  final DatabaseService _databaseService;
  final FileStorageManager _storageManager;
  RealtimeSubscription? _messageListener;

  MessengerRepository({required DatabaseService databaseService, required FileStorageManager storage})
      : _databaseService = databaseService,
        _storageManager = storage;

  String? _userId;
  List<Room> _chats = [];
  MessagesList? _currentChatMessages;
  StreamSubscription? _listener;

  String get userId => _userId ?? '';
  set userId(String newUserId) => _userId = newUserId;

  BehaviorSubject<List<Room>> chatsStream = BehaviorSubject.seeded([]);
  BehaviorSubject<List<ChatItem>> currentChatItemsStream = BehaviorSubject.seeded([]);

  Room? currentRoom;

  void closeChat() {
    currentRoom = null;
    _currentChatMessages = null;
    currentChatItemsStream.add([]);
  }

  void clear() {
    _userId = null;
    _currentChatMessages = null;
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

  Future<void> preloadChats() async {
    _chats = await _databaseService.messages.getUserChats(_userId!);
    // chatsStream.add(_chats);
    _loadChatsPreviewMessages();
  }

  Future<void> sendImages(List<XFile> images) async {
    if (currentRoom?.id == _needCreateRoomId) await _createRoom();
    final List<Uint8List> bytes = [];

    for (var i in images) {
      bytes.add(await i.readAsBytes());
    }

    final urls = await _storageManager.uploadMessageImages(bytes);

    for (var i in urls) {
      await _databaseService.messages.sendMessageDirect(
        roomId: currentRoom!.id,
        content: '',
        senderId: _userId!,
        images: [i],
      );
    }
  }

  Future<void> sendMessage(String content) async {
    if (currentRoom?.id == _needCreateRoomId) await _createRoom();

    await _databaseService.messages.sendMessageDirect(
      roomId: currentRoom!.id,
      content: content,
      senderId: _userId!,
    );
  }

  void searchChat(String query) {
    final list = <Room>[];

    for (Room i in _chats) {
      if (i.announcement.title.contains(query)) {
        list.add(i);
      }
    }

    chatsStream.add(list);
  }

  int notificationsAmount() {
    int count = 0;
    for (var i in _chats) {
      if (i.lastMessage == null) continue;
      if (i.lastMessage?.wasRead == null && !i.lastMessage!.owned) count++;
    }

    return count;
  }

  void refreshSubscription() async {
    await _listener?.cancel();
    //   await _messageListener?.close();
    _messageListener = _databaseService.messages.getMessagesSubscription();
    _listener = _messageListener?.stream.listen(_listenMessages);
    log('subscription refreshed');
  }

  Future<void> _createRoom() async {
    final roomId = await _databaseService.messages.createRoomDirect(
      _userId!,
      currentRoom!.announcement.creatorData.uid,
      currentRoom!.announcement.id,
    );

    currentRoom = await _databaseService.messages.getRoom(roomId, _userId!);

    _chats.add(currentRoom!);
    chatsStream.add(_chats);

    refreshSubscription();
  }

  void _selectRoomById(String id) {
    final Message? lastMessage = _chats[_findChatById(id)!].lastMessage;
    currentRoom = _chats[_findChatById(id)!];
    _currentChatMessages = MessagesList(lastMessage != null ? [lastMessage] : []);
    currentChatItemsStream.add(lastMessage != null
        ? [
            MessagesGroupData(messages: [lastMessage])
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

    _createEmptyRoom(announcement);
  }

  void _createEmptyRoom(Announcement announcement) {
    currentRoom = Room(
        id: _needCreateRoomId,
        chatName: '',
        otherUserId: announcement.creatorData.uid,
        otherUserName: announcement.creatorData.displayName,
        otherUserPhone: announcement.creatorData.phone,
        otherUserAvatarUrl: announcement.creatorData.imageUrl,
        announcement: announcement);

    _currentChatMessages = MessagesList([]);
    currentChatItemsStream.add([]);
  }

  _upChannelFrom(int index) {
    final chat = _chats.removeAt(index);
    _chats.insert(0, chat);
  }

  Future<List<Message>> _getChatMessages(chatId, {int? limit}) =>
      _databaseService.messages.getChatMessages(chatId, _userId!, limit: limit);

  void _loadChatsPreviewMessages() async {
    for (int i = 0; i < _chats.length; i++) {
      final chat = _chats[i];
      final messages = await _getChatMessages(chat.id, limit: 1);
      if (messages.isNotEmpty) {
        _chats[i].lastMessage = messages.last;
      }
    }
    _sortChats();
    chatsStream.add(_chats);
  }

  void _sortChats() {
    _chats.sort((a, b) => a.compareTo(b));
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
    final messages = await _getChatMessages(id);
    if (messages.isNotEmpty) {
      _currentChatMessages = MessagesList(messages);
      currentChatItemsStream.add(_currentChatMessages!.toSortedChatItems);
    }
  }

  void _listenMessages(RealtimeMessage event) async {
    if (event.events.contains('databases.*.collections.*.documents.*.create')) {
      _handleCreating(event);
    }
    if (event.events.contains('databases.*.collections.*.documents.*.update')) {
      _handleUpdates(event);
    }
  }

  void _handleCreating(RealtimeMessage event) async {
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

  void _markAllMessagesAsRead() => _databaseService.messages.markMessagesAsRead(currentRoom!.id, _userId!);

  void _addMessageToCurrentRoom(data, Message message) {
    _currentChatMessages!.addMessage(message);
    currentChatItemsStream.add(_currentChatMessages!.toSortedChatItems);
    if (message.senderId != _userId) {
      _databaseService.messages.markMessageAsRead(data['\$id']);
    }
  }

  void _getNewRoom(data) async {
    final room = await _databaseService.messages.getRoom(data['roomId'], _userId!);
    final messages = await _getChatMessages(room.id);
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
    _currentChatMessages!.updateMessage(messageData, _userId!);
    currentChatItemsStream.add(_currentChatMessages!.toSortedChatItems);
  }

  _updateRoomsPreviewMessages(Map<String, dynamic> data) {
    for (int i = 0; i < _chats.length; i++) {
      if (_chats[i].lastMessage?.id == data['\$id']) {
        _changeLastMessage(i, Message.fromJson(data, _userId!));
      }
    }
  }
}
