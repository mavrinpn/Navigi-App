import 'dart:convert';

import 'package:smart/services/parameters_parser.dart';

part 'item_parameters.dart';

part 'parameter.dart';

class SubcategoryItem {
  final String? id;
  final String _name;
  final String _subcategoryId;

  SubcategoryItem(
      {required String name, required this.id, required String subcategoryId})
      : _subcategoryId = subcategoryId,
        _name = name;

  String get name => _name;

  String get subcategory => _subcategoryId;

  String get title => _name;

  SubcategoryItem.fromJson(Map<String, dynamic> json1)
      : _name = json1['name'] ?? '',
        id = json1['\$id'],
        _subcategoryId = json1['sub_category'] ?? '';

  SubcategoryItem.withName(String name, String subCategory)
      : _name = name,
        _subcategoryId = subCategory,
        id = null;
}
