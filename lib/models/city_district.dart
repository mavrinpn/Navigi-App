part of 'announcement.dart';

class CityDistrict {
  static const double _defaultLatitude = 0;
  static const double _defaultLongitude = 0;

  String get name {
    final locale = currentLocaleShortName.value;
    return locale == 'fr' ? nameFr : nameAr;
  }

  final double latitude;
  final double longitude;
  final String nameFr;
  final String nameAr;
  final String id;
  final String cityId;

  CityDistrict({
    required this.latitude,
    required this.longitude,
    required this.nameFr,
    required this.nameAr,
    required this.id,
    required this.cityId,
  });

  CityDistrict.fromJson(Map<String, dynamic> json)
      : id = json['\$id'],
        cityId = json['city_id'],
        latitude = json['latitude'] ?? _defaultLatitude,
        longitude = json['longitude'] ?? _defaultLongitude,
        nameFr = json['name'] ?? json['nameFr'],
        nameAr = json['nameAr'];

  CityDistrict.none()
      : latitude = _defaultLatitude,
        longitude = _defaultLongitude,
        nameFr = '',
        nameAr = '',
        cityId = '',
        id = '';
}
