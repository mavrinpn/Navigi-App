import 'package:smart/models/static_parameters.dart';

import 'creator_data.dart';

class Announcement {
  final String title;
  final String description;
  final int totalViews;
  final double price;
  final List images;
  final String announcementId;
  final StaticParameters staticParameters;
  final CreatorData creatorData;
  final String _createdAt;

  Announcement(
      {required this.title,
      required String created,
      required this.description,
      required this.totalViews,
      required this.price,
      required this.images,
      required this.announcementId,
      required this.staticParameters,
      required this.creatorData})
      : _createdAt = created;

  Announcement.fromJson({required Map<String, dynamic> json})
      : title = json['name'],
        description = json['description'],
        creatorData = CreatorData(),
        price = double.parse(json['price'].toString()),
        images = json['images'],
        staticParameters = StaticParameters(parameters: json['parametrs']),
        totalViews = json['total_views'],
        _createdAt = json['\$createdAt'],
        announcementId = json['\$id'];

  @override
  String toString() => title;

  String get createdAt {
    final gotData = DateTime.parse(_createdAt);
    final String month = _addZeroInStart(gotData.month);
    final String day = _addZeroInStart(gotData.day);
    final String hour = _addZeroInStart(gotData.hour);
    final String minutes = _addZeroInStart(gotData.minute);
    return '$month.$day $hour:$minutes';
  }

  String _addZeroInStart(int num) => num.toString().length > 1 ? num.toString() : '0$num';

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
