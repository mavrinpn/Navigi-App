class UserData {
  final String id;
  String name;
  final double rating;
  final bool verified;
  final String imageUrl;
  final String _atService;
  final String phone;

  UserData({
    required this.id,
    required this.name,
    required this.rating,
    required this.verified,
    required this.imageUrl,
    required this.phone,
    required String createdAt,
  }) : _atService = createdAt;

  UserData.fromJson(Map<String, dynamic> json)
      : id = json['\$id'],
        name = json['name'],
        rating = json['rating'] != null ? (double.tryParse('${json['rating']['score']}') ?? -1) : -1,
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

  String _addZeroInStart(int num) => num.toString().length > 1 ? num.toString() : '0$num';
}
