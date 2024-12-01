import 'dart:async';

import 'package:appwrite/models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:smart/feature/messenger/data/models/chat_user_info.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/models/messenger/message.dart';

class Room {
  String id;
  String chatName;
  String? otherUserAvatarUrl;
  String otherUserId;
  String otherUserName;
  String otherUserPhone;
  Message? lastMessage;
  Announcement announcement;
  final Future<bool> Function(String)? onlineGetter;
  bool online = false;

  final BehaviorSubject<bool> onlineRefreshStream = BehaviorSubject();

  Room({
    required this.id,
    required this.chatName,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserPhone,
    required this.otherUserAvatarUrl,
    required this.announcement,
    this.lastMessage,
    this.onlineGetter,
  }) {
    _refreshOnlineStatus();
  }

  Room.fromDocument(
    Document doc,
    ChatUserInfo otherUser,
    String userId, {
    this.onlineGetter,
  })  : announcement = Announcement.fromJson(
          json: doc.data['announcement'],
          subcollTableId: '',
        ),
        chatName = '${otherUser.name} ${doc.data['announcement']['name']}',
        otherUserPhone = otherUser.phone,
        otherUserId = otherUser.id,
        otherUserAvatarUrl = otherUser.image,
        otherUserName = otherUser.name,
        lastMessage = doc.data['lastMessage'] != null ? Message.fromJson(doc.data['lastMessage'], userId) : null,
        id = doc.$id {
    _refreshOnlineStatus();
  }

  _refreshOnlineStatus() async {
    if (onlineGetter != null) {
      Timer.periodic(const Duration(seconds: 30), (timer) async {
        online = await onlineGetter!(otherUserId);
        onlineRefreshStream.add(online);
      });
    }
  }

  int compareTo(Room other) {
    if (lastMessage == null || other.lastMessage == null) {
      if (other.lastMessage == null) return 0;
      return -1;
    }
    final dt = DateTime.parse(lastMessage!.createdAt);
    final otherDt = DateTime.parse(other.lastMessage!.createdAt);

    return otherDt.difference(dt).inSeconds;
  }
}
