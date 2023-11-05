import 'package:smart/utils/functions.dart';

class Message {
  String content;
  List? images;
  String createdAt;
  DateTime createdAtDt;
  String senderId;
  String id;
  bool owned;
  DateTime? wasRead;

  Message(
      {required this.id,
      required this.content,
      required this.senderId,
      required this.createdAt,
      required this.createdAtDt,
      required this.owned,
      this.wasRead,
      this.images});

  Message.fish({bool owned_ = false, DateTime? read})
      : id = '',
        content =
            'Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s',
        senderId = '',
        createdAt = dateTimeToString(DateTime.now()),
        createdAtDt = DateTime.now(),
        wasRead = read,
        owned = owned_;
}
