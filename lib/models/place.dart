part of 'announcement.dart';

class CityDistrict {
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
        latitude = json['latitude'],
        longitude = json['longitude'],
        name = json['name'];

  CityDistrict.fish()
      : latitude = 37.570802,
        longitude = 126.975959,
        name = 'Séoul',
        cityId = 'asdasdawfe',
        id = '64a69ed363ce7489b87c';
}
