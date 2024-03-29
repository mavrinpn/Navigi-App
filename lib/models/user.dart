class UserData {
  final String id;
  String name;
  final double score;
  final bool verified;
  final String imageUrl;
  final String _atService;
  final String phone;

  UserData({
    required this.id,
    required this.name,
    required this.score,
    required this.verified,
    required this.imageUrl,
    required this.phone,
    required String createdAt,
  }) : _atService = createdAt;

  // UserData({
  //   this.name = 'John E.',
  //   this.score = 4.9,
  //   this.verified = true,
  //   this.imageUrl =
  //       'http://143.244.206.96//v1/storage/buckets/64abdd27c9326a1cdfde/files/64abe12a025c0060fe51/view?project=64fb37419dc681fa6860',
  //   //admin.navigidz.online
  //   String createdAt = '2022-10-01',
  //   this.phone = '12345678910',
  // }) : _atService = createdAt;

  UserData.fromJson(Map<String, dynamic> json)
      : id = json['\$id'],
        name = json['name'],
        score = json['score'] != null
            ? (double.tryParse('${json['score']}') ?? -1)
            : -1,
        verified = json['verified'],
        imageUrl = json['image_url'] ?? '',
        _atService = json['\$createdAt'],
        phone = json['phone'];

  String get atService {
    final gotData = DateTime.tryParse(_atService) ?? DateTime.now();
    final int year = gotData.year;
    final String month = _addZeroInStart(gotData.month);
    final String day = _addZeroInStart(gotData.day);
    return '$day.$month.$year';
  }

  String get displayName => _capitalizeName();

  String _capitalizeName() {
    String n;
    if (name.split(' ').length > 1) {
      String last = name.split(' ')[name.split(' ').length - 1];
      String first = name.substring(0, name.lastIndexOf(last));

      n = '${first[0].toUpperCase() + first.substring(1).toLowerCase()} ${last[0].toUpperCase()}.';
    } else {
      if (name.length > 1) {
        n = name[0].toUpperCase() + name.substring(1).toLowerCase();
      } else {
        n = '';
      }
    }
    return n;
  }

  String _addZeroInStart(int num) =>
      num.toString().length > 1 ? num.toString() : '0$num';
}
