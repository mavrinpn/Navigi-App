import 'package:smart/models/user.dart';

class Review {
  final String id;
  final String creatorId;
  final UserData creator;
  final String text;
  final String status;
  final String receiverId;
  final int score;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.creatorId,
    required this.creator,
    required this.text,
    required this.status,
    required this.receiverId,
    required this.score,
    required this.createdAt,
  });
  Review.fromJson(Map<String, dynamic> json)
      : id = json['\$id'],
        creator = UserData.fromJson(json['creator']),
        creatorId = json['creatorId'],
        createdAt = DateTime.parse(json['\$createdAt']),
        text = json['text'],
        status = json['status'],
        receiverId = json['receiverId'],
        score =
            json['score'] != null ? (int.tryParse('${json['score']}') ?? 0) : 0;
}
