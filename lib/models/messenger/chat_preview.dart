import 'package:appwrite/models.dart';
import 'package:smart/models/messenger/message.dart';

class ChatPreview {
  String id;
  String chatName;
  String otherUserAvatarUrl;
  String otherUserId;
  Message? lastMessage;

  ChatPreview(
      {required this.id,
      required this.chatName,
      required this.otherUserId,
      required this.otherUserAvatarUrl,
      this.lastMessage});
}
