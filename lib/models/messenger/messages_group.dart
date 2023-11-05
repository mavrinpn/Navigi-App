import 'package:smart/models/messenger/chat_item.dart';
import 'package:smart/models/messenger/message.dart';

class MessagesGroup implements ChatItem {
  List<Message> messages;

  MessagesGroup({required this.messages}) : assert(messages.isNotEmpty, 'messages cannot be empty');

  void addMessage(Message message) => messages.add(message);

  DateTime get sentAt => messages.last.createdAtDt;

  bool get owned => messages.last.owned;
}
