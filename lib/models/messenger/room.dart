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
}
