import 'dart:convert';

class SubCategoryItem {
  String? name;
  String? subcategoryId;
  Map<String, dynamic>? parametrs;

  SubCategoryItem({required this.name, required this.subcategoryId, required this.parametrs});

  SubCategoryItem.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    subcategoryId = json['sub_category'] ?? '';
    final mapString = json['parametrs'];
    parametrs = jsonDecode(jsonEncode(mapString));
  }
}