import 'package:smart/main.dart';

class City {
  final String id;
  final String nameFr;
  final String nameAr;

  String get name {
    final locale = currentLocaleShortName.value;
    return locale == 'fr' ? nameFr : nameAr;
  }

  City.fromJson(Map<String, dynamic> json)
      : id = json['\$id'],
        nameFr = json['name'] ?? json['nameFr'],
        nameAr = json['nameAr'];

  City.none()
      : nameFr = '',
        nameAr = '',
        id = '';
}
