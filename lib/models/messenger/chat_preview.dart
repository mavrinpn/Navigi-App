import 'package:smart/models/messenger/message.dart';

class ChatPreview {
  String chatName;
  String otherUserAvatarUrl;
  Message? lastMessage;

  ChatPreview(
      {required this.chatName,
      required this.otherUserAvatarUrl,
      this.lastMessage});
}
