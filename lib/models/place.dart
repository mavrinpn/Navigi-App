part of 'announcement.dart';

class CityDistrict {
  static const double _defaultLatitude = 36.783;
  static const double _defaultLongitude = 3.067;

  final double latitude;
  final double longitude;
  final String name;
  final String id;
  final String cityId;

  CityDistrict({
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.id,
    required this.cityId,
  });

  CityDistrict.fromJson(Map<String, dynamic> json)
      : id = json['\$id'],
        cityId = json['cityId'],
        latitude = json['latitude'] ?? _defaultLatitude,
        longitude = json['longitude'] ?? _defaultLongitude,
        name = json['name'];

  CityDistrict.none()
      : latitude = _defaultLatitude,
        longitude = _defaultLongitude,
        name = 'Not specified',
        cityId = 'Not specified',
        id = '0';
}
