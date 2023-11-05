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
  final RealtimeSubscription? _messageListener;

  MessengerRepository({required DatabaseService databaseService})
      : _databaseService = databaseService,
        _messageListener = databaseService.getMessagesSubscription();

  String? _userId;
  List<Room> _chats = [];
  List<Message> _currentChatMessages = [];

  set userId(String newUserId) => _userId = newUserId;

  /// Эта штука нужна чтобы рисовать все чаты на экране all_chats,
  /// просто ставишь билдер через эту штука и берешиь из него список чатов
  BehaviorSubject<List<Room>> chatsStream = BehaviorSubject.seeded([]);

  /// Эта штука нужна чтобы рисовать все сообщения на экране чата, чуть позже
  /// переделаю на chat item со всеми разделителями
  BehaviorSubject<List<ChatItem>> currentChatItemsStream =
      BehaviorSubject.seeded([]);

  Room? currentRoom;

  void clear() {
    _userId = null;
    _currentChatMessages.clear();
    _chats.clear();

    chatsStream.add(_chats);
    currentChatItemsStream.add([]);
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
    _messageListener?.stream.listen(_listenMessages);
  }

  void sendMessage(String content) async {
    if (currentRoom?.id == _needCreateRoomId) await _createRoom();

    _databaseService.sendMessage(
      roomId: currentRoom!.id,
      teamId: currentRoom!.teamId,
      content: content,
      senderId: _userId!,
    );
  }

  Future<void> _createRoom() async {
    final roomData = await _databaseService.createRoom(
        [_userId!, currentRoom!.announcement.creatorData.uid],
        currentRoom!.announcement.id);

    currentRoom = await _databaseService.getRoom(roomData['room'], _userId!);
    _chats.add(currentRoom!);
    chatsStream.add(_chats);
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
    for (var i in _chats) {
      if (i.announcement.id == announcement.id) {
        return _selectRoomById(i.id);
      }
    }

    currentRoom = Room(
        id: _needCreateRoomId,
        chatName: '',
        otherUserId: announcement.creatorData.uid,
        otherUserName: announcement.creatorData.name,
        teamId: _needCreateRoomId,
        otherUserAvatarUrl: null,
        announcement: announcement);

    _currentChatMessages.clear();
    currentChatItemsStream.add(_sortMessagesByDate(_currentChatMessages));
  }

  void _loadChatsMessages() async {
    for (int i = 0; i < _chats.length; i++) {
      final chat = _chats[i];
      final messages =
          await _databaseService.getChatMessages(chat.id, _userId!);
      if (messages.isNotEmpty) {
        _chats[i].lastMessage = messages.last;
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

  void _listenMessages(RealtimeMessage event) async {
    print(event.payload);
    print(event.events.last);
    final data = event.payload;
    final message = Message(
        id: data['\$id'],
        content: data['content'],
        senderId: data['creatorId'],
        images: data['images'],
        owned: _userId == data['creatorId'],
        createdAt: data['\$createdAt'],
        createdAtDt: DateTime.parse(data['\$createdAt'])
            .add(DateTime.now().timeZoneOffset));

    if (data['roomId'] == currentRoom?.id) {
      _currentChatMessages.add(message);
      currentChatItemsStream.add(_sortMessagesByDate(_currentChatMessages));
    }

    final index = _findChatById(data['roomId']);

    if (index != null) {
      _chats[index].lastMessage = message;
      chatsStream.add(_chats);
    } else {
      final room = await _databaseService.getRoom(data['roomId'], _userId!);
      final messages =
          await _databaseService.getChatMessages(room.id, _userId!);
      room.lastMessage = messages[0];
      _chats.add(room);
      chatsStream.add(_chats);
    }
  }

  List<ChatItem> _sortMessagesByDate(List<Message> messages) {
    final List<ChatItem> items = [];
    for (Message message in messages) {
      if (items.isEmpty) {
        items.add(DateSplitter(dateTime: message.createdAtDt));
      }
      if (items.last is DateSplitter) {
        items.add(MessagesGroup(messages: [message]));
      } else {
        final lastGroup = items.last as MessagesGroup;
        bool timeCondition =
            (lastGroup.sentAt.difference(message.createdAtDt).inSeconds).abs() >
                30;
        if (lastGroup.owned != message.owned || timeCondition) {
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

  void _markAllMessagesAsRead() async {
    print('хуй');
    _databaseService.markMessagesAsRead(currentRoom!.id, _userId!);
  }
}
