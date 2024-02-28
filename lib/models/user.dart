class UserData {
  String name;
  final double score;
  final bool verified;
  final String imageUrl;
  final String _atService;
  final String phone;

  UserData(
      {this.name = 'John E.',
      this.score = 4.9,
      this.verified = true,
      this.imageUrl =
          'http://143.244.206.96//v1/storage/buckets/64abdd27c9326a1cdfde/files/64abe12a025c0060fe51/view?project=64fb37419dc681fa6860',
          //admin.navigidz.online
      String createdAt = '2022-10-01',
      this.phone = '12345678910'})
      : _atService = createdAt;

  UserData.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        score = 4.9,
        verified = json['verified'],
        imageUrl = json['image_url'] ??
            'http://143.244.206.96/v1/storage/buckets/64abdd27c9326a1cdfde/files/64abe12a025c0060fe51/view?project=64fb37419dc681fa6860',
            //admin.navigidz.online
        _atService = json['\$createdAt'],
        phone = json['phone'];

  String get atService {
    final gotData = DateTime.parse(_atService);
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
      n = name[0].toUpperCase() + name.substring(1).toLowerCase();
    }
    return n;
  }

  String _addZeroInStart(int num) =>
      num.toString().length > 1 ? num.toString() : '0$num';
}
