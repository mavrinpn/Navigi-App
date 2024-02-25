import 'dart:typed_data';

class Category {
  String name;

  String nameFr;
  String nameAr;

  String? imageUrl;
  Uint8List? bytes;
  String? id;

  Category({this.imageUrl, required this.name, required this.id, required this.bytes, required this.nameAr, required this.nameFr});

  String getLocalizedName(String locale) {
    if (locale == 'fr') {
      return nameFr;
    } else if (locale == 'ar') {
      return nameAr;
    } else {
      return name;
    }
  }

  Category.fromJson(Map<String, dynamic> json) :
        imageUrl = json['image'],
        name = json['name'],
        nameAr = json['nameAr'],
        nameFr = json['nameFr'],
        id = json['\$id'];
}
