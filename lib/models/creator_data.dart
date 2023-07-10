part of 'announcement.dart';

class CreatorData {
  final String uid;
  final String name;
  final double score;
  final PlaceData place;
  final int _distance;
  final bool verified;

  CreatorData(
      {this.name = 'John E.', this.score = 4.1, this.uid = 'aboba', int d = 4, this.verified = false})
      : _distance = d,
        place = PlaceData.fish();

  String get distance => '$_distance km de vous';
}
