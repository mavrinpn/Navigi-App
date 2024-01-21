class ChatUserInfo {
  final String id;
  final String name;
  final String image;

  ChatUserInfo.fromJson(Map<String, dynamic> json)
      : id = json['\$id'],
        name = json['name'],
        image = json['image_url'] ?? '';
}
