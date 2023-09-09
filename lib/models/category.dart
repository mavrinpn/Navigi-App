import 'dart:typed_data';

class Category {
  String? name;
  String? imageUrl;
  Uint8List? bytes;
  String? id;

  Category({this.imageUrl, required this.name, required this.id, required this.bytes});

  Category.fromJson(Map<String, dynamic> json) :
        imageUrl = json['image'],
        name = json['name'],
        id = json['\$id'];
}
