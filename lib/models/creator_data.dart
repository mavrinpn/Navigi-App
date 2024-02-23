part of 'announcement.dart';

class CreatorData {
  final String uid;
  final String name;
  final double score;
  final String imageUrl;
  final CityDistrict place;
  final int _distance;
  final bool verified;

  CreatorData(
      {this.name = 'John E.',
      this.score = 4.1,
      this.uid = 'aboba',
      int d = 4,
      this.verified = false})
      : _distance = d,
        imageUrl = '',
        place = CityDistrict.fish();

  CreatorData.fromJson({required Map<String, dynamic>? data})
      : _distance = 4,
        place = CityDistrict.fish(),
        name = data != null ? data['name'] : 'John E.',
        score = 4.1,
        verified = data != null ? data['verified'] : true,
        imageUrl = data != null ? data['image_url'] ?? '' : '',
        uid = data != null ? data['\$id'] : 'aboba';

  String get distance => '$_distance km de vous';

  UserData toUserData() => UserData(
        name: name,
        verified: verified,
        imageUrl: imageUrl,
      );
}
