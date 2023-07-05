part of 'announcement.dart';

class AnnouncementData {
  final String title;
  final String creatorName;
  final double price;
  final String imageUrl;
  final String announcementId;

  AnnouncementData(
      {required this.title,
        required this.price,
        required this.imageUrl,
        required this.announcementId,
        required this.creatorName});

  AnnouncementData.fromJson({required Map<String, dynamic> json})
      : title = json['name'],
        creatorName = 'aboba',
        price = double.parse(json['price'].toString()),
        imageUrl = json['images'][0],
        announcementId = json['\$id'];

  @override
  String toString() => title;

  String get stringPrice {
    String reversed = price.toString().split('.')[0].split('').reversed.join();

    for (int i = 0; i < reversed.length; i += 4) {
      try {
        reversed = '${reversed.substring(0, i)} ${reversed.substring(i)}';
        // ignore: empty_catches
      } catch (e) {}
    }

    return '${reversed.split('').reversed.join()}DZD';
  }
}