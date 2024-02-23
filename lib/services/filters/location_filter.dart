import 'package:appwrite/appwrite.dart';
import 'package:geolocator/geolocator.dart';

class LocationFilter {
  static Future<List<String>> getLocationFilterForRadius(double radius) async {
    await Geolocator.requestPermission();

    final location = await Geolocator.getCurrentPosition();

    final minLatitude = location.latitude - radius / 90;
    final maxLatitude = location.latitude + radius / 90;
    final minLongitude = location.longitude - radius / 111;
    final maxLongitude = location.longitude + radius / 111;

    final filters = [
      Query.between('longitude', minLongitude, maxLongitude),
      Query.between('latitude', minLatitude, maxLatitude),
    ];

    return filters;
  }
}
