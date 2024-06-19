import 'dart:typed_data';

import 'package:smart/models/subcategory.dart';

class Category {
  String name;

  String nameFr;
  String nameAr;

  String? imageUrl;
  Uint8List? bytes;
  String? id;
  List<Subcategory> subcategories;

  Category({
    this.imageUrl,
    required this.name,
    required this.id,
    required this.bytes,
    required this.nameAr,
    required this.nameFr,
    required this.subcategories,
  });

  String getLocalizedName(String locale) {
    if (locale == 'fr') {
      return nameFr;
    } else if (locale == 'ar') {
      return nameAr;
    } else {
      return name;
    }
  }

  Category.fromJson(Map<String, dynamic> json)
      : imageUrl = json['image'],
        name = json['name'],
        nameAr = json['nameAr'],
        nameFr = json['nameFr'],
        subcategories = [],
        id = json['\$id'];

  Category copyWith({
    String? name,
    String? nameFr,
    String? nameAr,
    String? imageUrl,
    Uint8List? bytes,
    String? id,
    List<Subcategory>? subcategories,
  }) {
    return Category(
      name: name ?? this.name,
      nameFr: nameFr ?? this.nameFr,
      nameAr: nameAr ?? this.nameAr,
      imageUrl: imageUrl ?? this.imageUrl,
      bytes: bytes ?? this.bytes,
      id: id ?? this.id,
      subcategories: subcategories ?? this.subcategories,
    );
  }

  @override
  bool operator ==(covariant Category other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.nameFr == nameFr &&
        other.nameAr == nameAr &&
        other.imageUrl == imageUrl &&
        other.bytes == bytes &&
        other.id == id;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        nameFr.hashCode ^
        nameAr.hashCode ^
        imageUrl.hashCode ^
        bytes.hashCode ^
        id.hashCode ^
        subcategories.hashCode;
  }
}
