import 'dart:convert';

class SubCategoryItem {
  String? name;
  String? subcategoryId;
  Map<String, dynamic>? parametrs;

  SubCategoryItem({required this.name, required this.subcategoryId, required this.parametrs});

  SubCategoryItem.fromJson(Map<String, dynamic> json1) {
    name = json1['name'] ?? '';
    subcategoryId = json1['sub_category'] ?? '';
    final mapString = json1['parametrs'];
    parametrs = jsonDecode(mapString);
  }
}