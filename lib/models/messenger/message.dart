import 'package:smart/utils/functions.dart';

class Message {
  String content;
  List<String>? images;
  String createdAt;
  String senderId;
  String id;
  bool owned;
  DateTime? wasRead;

  Message(
      {required this.id,
      required this.content,
      required this.senderId,
      required this.createdAt,
      required this.owned,
      this.wasRead,
      this.images});

  Message.fish()
      : id = '',
        content =
            'Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s',
        senderId = '',
        createdAt = dateTimeToString(DateTime.now()),
        owned = false;
}
