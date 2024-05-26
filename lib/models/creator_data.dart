part of 'announcement.dart';

class CreatorData {
  final String uid;
  final String name;
  final double rating;
  final String imageUrl;
  final CityDistrict place;
  final int _distance;
  final bool verified;
  final String phone;

  get displayName => _displayName();
  String _displayName() {
    if (name.isEmpty && name.length > 8) {
      return 'user${uid.substring(uid.length - 8)}';
    }
    return name;
  }

  CreatorData.fromJson({required Map<String, dynamic> data})
      : _distance = 4,
        place = CityDistrict.none(),
        name = data['name'] ?? '',
        phone = data['phone'] ?? '',
        rating = data['rating'] != null ? (double.tryParse('${data['rating']['score']}') ?? 0) : 0,
        verified = data['verified'] ?? true,
        imageUrl = data['image_url'] ?? '',
        uid = data['\$id'] ?? 'aboba';

  String get distance => '$_distance km de vous';

  UserData toUserData() => UserData(
        id: uid,
        name: name,
        verified: verified,
        imageUrl: imageUrl,
        rating: rating,
        phone: phone,
        createdAt: '',
      );
}
