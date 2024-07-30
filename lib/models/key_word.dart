import 'package:smart/main.dart';

class KeyWord {
  final String id;
  final String subcategoryId;
  final String nameAr;
  final String nameFr;
  final String? mark;
  final String? model;
  final String? type;

  String localizedName() {
    final locale = currentLocaleShortName.value;
    if (locale == 'fr') {
      return nameFr;
    } else {
      return nameAr;
    }
  }

  KeyWord({
    required this.id,
    required this.subcategoryId,
    required this.nameAr,
    required this.nameFr,
    required this.mark,
    required this.model,
    required this.type,
  });

  factory KeyWord.fromJson(Map<String, dynamic> json) {
    return KeyWord(
      id: json['\$id'],
      subcategoryId: json['subcategory_id'] ?? '',
      nameAr: json['nameAr'] ?? '',
      nameFr: json['nameFr'] ?? '',
      mark: json['mark'],
      model: json['model'],
      type: json['type'],
    );
  }
}
