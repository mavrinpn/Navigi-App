class Message {
  String content;
  List<String>? images;
  String createdAt;
  String senderId;
  String id;

  Message(
      {required this.id,
      required this.content,
      required this.senderId,
      required this.createdAt,
      this.images});
}
