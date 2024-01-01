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
