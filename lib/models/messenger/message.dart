class Message {
  String content;
  List<String>? images;
  String createdAt;
  String senderId;

  Message(
      {required this.content,
      required this.senderId,
      required this.createdAt,
      this.images});
}
