class CreatorData {
  final String name;
  final double score;
  final String place;
  final int _distance;

  CreatorData(
      {this.name = 'John E.',
      this.place = 'Ville',
      this.score = 4.1,
      int d = 4})
      : _distance = d;

  String get distance => '$_distance km de vous';
}
