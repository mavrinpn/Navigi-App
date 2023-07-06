part of 'announcement.dart';

class PlaceData {
  final double x;
  final double y;
  final String name;
  final String id;

  PlaceData({required this.x, required this.y, required this.name, required this.id});

  set name(String namee) => name = namee;

  PlaceData.fromJson(Map<String, dynamic> json):
      id = json['\$id'],
      x = json['x_point'],
      y = json['y_point'],
      name = json['name'];

  PlaceData.fish()
      : x = 37.570802,
        y = 126.975959,
        name = 'Séoul',
        id = '64a69ed363ce7489b87c';
}
