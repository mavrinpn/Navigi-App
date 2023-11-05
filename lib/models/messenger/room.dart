import 'package:appwrite/models.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/models/messenger/message.dart';

class Room {
  String id;
  String teamId;
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
      required this.teamId,
      required this.otherUserAvatarUrl,
      required this.announcement,
      this.lastMessage});
}
