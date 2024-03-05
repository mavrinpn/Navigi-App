part of 'announcement.dart';

class CreatorData {
  final String uid;
  final String name;
  final double score;
  final String imageUrl;
  final CityDistrict place;
  final int _distance;
  final bool verified;
  final String phone;

  CreatorData({
    this.name = 'John E.',
    this.score = 4.1,
    this.uid = 'aboba',
    this.phone = '',
    int d = 4,
    this.verified = false,
  })  : _distance = d,
        imageUrl = '',
        place = CityDistrict.fish();

  CreatorData.fromJson({required Map<String, dynamic> data})
      : _distance = 4,
        place = CityDistrict.fish(),
        name = data['name'] ?? '',
        phone = data['phone'] ?? '',
        score = data['score'] != null
            ? (double.tryParse('${data['score']}') ?? -1)
            : -1,
        verified = data['verified'] ?? true,
        imageUrl = data['image_url'] ?? '',
        uid = data['\$id'] ?? 'aboba';

  String get distance => '$_distance km de vous';

  UserData toUserData() => UserData(
        id: uid,
        name: name,
        verified: verified,
        imageUrl: imageUrl,
        score: score,
        phone: phone,
        createdAt: '',
      );
}
