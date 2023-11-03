import 'package:appwrite/models.dart';
import 'package:smart/models/messenger/message.dart';

class Room {
  String id;
  String teamId;
  String chatName;
  String? otherUserAvatarUrl;
  String otherUserId;
  Message? lastMessage;

  Room(
      {required this.id,
      required this.chatName,
      required this.otherUserId,
      required this.teamId,
      required this.otherUserAvatarUrl,
      this.lastMessage});
}
