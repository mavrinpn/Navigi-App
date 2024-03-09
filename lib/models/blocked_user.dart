class BlockedUser {
  final String id;
  final String authorId;
  final String blockedUserId;

  BlockedUser({
    required this.id,
    required this.authorId,
    required this.blockedUserId,
  });
  BlockedUser.fromJson(Map<String, dynamic> json)
      : id = json['\$id'],
        authorId = json['authorId'],
        blockedUserId = json['blockedUserId'];
}
