import 'package:smart/models/messenger/chat_item.dart';
import 'package:smart/models/messenger/date_splitter.dart';
import 'package:smart/models/messenger/message.dart';
import 'package:smart/models/messenger/messages_group.dart';

class MessagesList {
  final List<Message> _messages;

  MessagesList(this._messages);

  List<ChatItem> get toSortedChatItems {
    if (_messages.isEmpty) return [];

    final List<ChatItem> items = [];
    items.add(DateSplitter(dateTime: _messages.first.createdAtDt));

    for (Message message in _messages) {
      if (items.last is DateSplitter) {
        items.add(MessagesGroupData(messages: [message]));
      } else {
        final lastGroup = items.last as MessagesGroupData;
        bool timeConditionToSplitGroups =
            (lastGroup.sentAt.difference(message.createdAtDt).inSeconds).abs() >
                30;
        if (lastGroup.owned != message.owned || timeConditionToSplitGroups) {
          if (lastGroup.diffDate(message.createdAtDt)) {
            items.add(DateSplitter(dateTime: message.createdAtDt));
          }

          items.add(MessagesGroupData(messages: [message]));
        } else {
          (items.last as MessagesGroupData).addMessage(message);
        }
      }
    }

    return items.reversed.toList();
  }

  Message? get lastMessage => _messages.last;

  int get length => _messages.length;

  void addMessage(Message message) => _messages.add(message);

  void updateMessage(Map<String, dynamic> messageData, String userId) {
    for (int i = 0; i < _messages.length; i++) {
      if (_messages[i].id == messageData['\$id']) {
        _messages[i] = Message.fromJson(messageData, userId);
      }
    }
  }
}
