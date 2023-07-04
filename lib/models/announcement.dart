class Announcement {
  final String? title;
  final String? creatorName;
  final double? price;
  final String? imageUrl;
  final String? announcementId;

  Announcement({required this.title, required this.price, required this.imageUrl, required this.announcementId, required this.creatorName});

  String get stringPrice {
    String reversed = price.toString().split('.')[0].split('').reversed.join();

    for (int i = 0; i < reversed.length; i += 4) {
      try {
        reversed = '${reversed.substring(0, i)} ${reversed.substring(i)}';
      } catch (e) {}
    }

    return '${reversed.split('').reversed.join()}DZD';
  }

  Announcement.fromJson(Map<String, dynamic> json) :
        imageUrl = json['image_url'],
        title = json['name'],
        creatorName = "asfd",
        price = json['price'],
        announcementId = json['\$id'];

}