import 'package:appwrite/models.dart';
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

  Message.fromJson(Map<String, dynamic> json, String userId)
      : id = json['\$id'],
        content = json['content'],
        senderId = json['creatorId'],
        images = json['images'],
        wasRead = json['wasRead'] != null
            ? DateTime.fromMillisecondsSinceEpoch(json['wasRead'])
            : null,
        owned = userId == json['creatorId'],
        createdAt = json['\$createdAt'],
        createdAtDt = DateTime.parse(json['\$createdAt'])
            .add(DateTime.now().timeZoneOffset);

  Message.fish({bool owned_ = false, DateTime? read})
      : id = '',
        content =
            'Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s',
        senderId = '',
        createdAt = dateTimeToString(DateTime.now()),
        createdAtDt = DateTime.now(),
        wasRead = read,
        owned = owned_;

  Message.fromDocument(Document doc, String userId)
      : id = doc.$id,
        content = doc.data['content'],
        senderId = doc.data['creatorId'],
        images = doc.data['images'],
        owned = userId == doc.data['creatorId'],
        createdAt = doc.$createdAt,
        createdAtDt =
            DateTime.parse(doc.$createdAt).add(DateTime.now().timeZoneOffset) {
    if (doc.data['wasRead'] != null) {
      wasRead =
          DateTime.fromMillisecondsSinceEpoch(doc.data['wasRead']);
    }
  }
}
