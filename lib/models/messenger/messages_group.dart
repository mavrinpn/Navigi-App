import 'package:smart/models/messenger/chat_item.dart';
import 'package:smart/models/messenger/message.dart';
import 'package:smart/utils/functions.dart';

class MessagesGroupData implements ChatItem {
  List<Message> messages;

  MessagesGroupData({required this.messages}) : assert(messages.isNotEmpty, 'messages cannot be empty');

  void addMessage(Message message) => messages.add(message);

  DateTime get sentAt => messages.last.createdAtDt;

  String get sentAtFormatted => dateTimeToString(messages.last.createdAtDt);

  bool get wasRead => messages.last.wasRead != null;

  bool get owned => messages.last.owned;

  bool diffDate(DateTime dt) {
    return (dt.year != sentAt.year || dt.month != sentAt.month || dt.day != sentAt.day);
  }
}
