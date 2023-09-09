part of 'announcement.dart';

class PlaceData {
  final double x;
  final double y;
  final String name;
  final String id;

  PlaceData({required this.x, required this.y, required this.name, required this.id});

  PlaceData.fromJson(Map<String, dynamic> json):
      id = json['\$id'],
      x = json['x'],
      y = json['y'],
      name = json['name'];

  PlaceData.fish()
      : x = 37.570802,
        y = 126.975959,
        name = 'Séoul',
        id = '64a69ed363ce7489b87c';
}
