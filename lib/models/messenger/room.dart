import 'dart:typed_data';

import 'package:appwrite/models.dart';
import 'package:smart/feature/messenger/data/models/chat_user_info.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/models/messenger/message.dart';

class Room {
  String id;
  String chatName;
  String? otherUserAvatarUrl;
  String otherUserId;
  String otherUserName;
  Message? lastMessage;
  Announcement announcement;

  Room(
      {required this.id,
      required this.chatName,
      required this.otherUserId,
      required this.otherUserName,
      required this.otherUserAvatarUrl,
      required this.announcement,
      this.lastMessage});

  Room.fromDocument(Document doc, Future<Uint8List> announcementImage,
      ChatUserInfo otherUser)
      : announcement = Announcement.fromJson(
            json: doc.data['announcement'], futureBytes: announcementImage),
        chatName = '${otherUser.name} ${doc.data['announcement']['name']}',
        otherUserId = otherUser.id,
        otherUserAvatarUrl = otherUser.image,
        otherUserName = otherUser.name,
        id = doc.$id;

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
