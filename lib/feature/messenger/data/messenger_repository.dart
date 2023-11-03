import 'package:appwrite/appwrite.dart';
import 'package:rxdart/rxdart.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/models/messenger/chat_preview.dart';
import 'package:smart/models/messenger/message.dart';
import 'package:smart/services/database_service.dart';

class MessengerRepository {
  static const String needCreateRoomId = 'NEED_CREATE_ROOM';

  final DatabaseService databaseService;
  final RealtimeSubscription? _messageListener;

  MessengerRepository({required this.databaseService})
      : _messageListener = databaseService.getMessagesSubscription();

  String? _userId;
  List<Room> _chats = [];
  List<Message> _currentChatMessages = [];

  set userId(String newUserId) => _userId = newUserId;

  /// Эта штука нужна чтобы рисовать все чаты на экране all_chats,
  /// просто ставишь билдер через эту штука и берешиь из него список чатов
  BehaviorSubject<List<Room>> chatsStream = BehaviorSubject.seeded([]);

  /// Эта штука нужна чтобы рисовать все сообщения на экране чата, чуть позже
  /// переделаю на chat item со всеми разделителями
  BehaviorSubject<List<Message>> currentChatMessagesStream =
      BehaviorSubject.seeded([]);

  Room? currentRoom;

  void clear() {
    _userId = null;
    _currentChatMessages.clear();
    _chats.clear();

    chatsStream.add(_chats);
    currentChatMessagesStream.add(_currentChatMessages);
  }

  void selectChat({String? id, Announcement? announcement}) async {
    assert(id != null || announcement != null, 'Что-то одно должно быть');
    if (id != null) {
      final Message? lastMessage = _chats[_findChatById(id)!].lastMessage;
      currentRoom = _chats[_findChatById(id)!];
      _currentChatMessages = lastMessage != null ? [lastMessage] : [];
      currentChatMessagesStream.add(lastMessage != null ? [lastMessage] : []);
      _loadChatMessages(id);
    } else {
      currentRoom = Room(
          id: needCreateRoomId,
          chatName: '',
          otherUserId: announcement!.creatorData.uid,
          teamId: needCreateRoomId,
          otherUserAvatarUrl: null,
          announcement: announcement);

      _currentChatMessages.clear();
      currentChatMessagesStream.add(_currentChatMessages);
    }
  }

  void preloadChats() async {
    _chats = await databaseService.getUserChats(_userId!);
    chatsStream.add(_chats);
    _loadChatsMessages();
    _messageListener?.stream.listen(_listenMessages);
  }

  void sendMessage(String content) async {
    if (currentRoom?.id == needCreateRoomId) {
      final roomData = await databaseService.createRoom(
          [_userId!, currentRoom!.announcement.creatorData.uid],
          currentRoom!.announcement.id);

      currentRoom = await databaseService.getRoom(roomData['room'], _userId!);
      _chats.add(currentRoom!);
      chatsStream.add(_chats);
    }

    databaseService.sendMessage(
      roomId: currentRoom!.id,
      teamId: currentRoom!.teamId,
      content: content,
      senderId: _userId!,
    );
  }



  void _loadChatsMessages() async {
    for (int i = 0; i < _chats.length; i++) {
      final chat = _chats[i];
      final messages = await databaseService.getChatMessages(chat.id, _userId!);
      if (messages.isNotEmpty) {
        _chats[i].lastMessage = messages.first;
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
    final messages = await databaseService.getChatMessages(id, _userId!);
    if (messages.isNotEmpty) {
      _currentChatMessages = messages;
      currentChatMessagesStream.add(_currentChatMessages);
    }
  }

  void _listenMessages(RealtimeMessage event) {
    print(event.payload);
    final data = event.payload;
    final message = Message(
        id: data['\$id'],
        content: data['content'],
        senderId: data['creatorId'],
        images: data['images'],
        owned: _userId == data['creatorId'],
        createdAt: data['\$createdAt']);

    if (data['roomId'] == currentRoom?.id) {
      _currentChatMessages.add(message);
      currentChatMessagesStream.add(_currentChatMessages);
    } else {
      _chats[_findChatById(data['roomId'])!].lastMessage = message;
      chatsStream.add(_chats);
    }
  }
}
