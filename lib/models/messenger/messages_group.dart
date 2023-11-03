import 'package:smart/models/messenger/chat_item.dart';
import 'package:smart/models/messenger/message.dart';

class MessagesGroup implements ChatItem{
  List<Message> messages;
  MessagesGroup({required this.messages});
}