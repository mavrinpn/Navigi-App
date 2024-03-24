import 'package:smart/models/item/item.dart';

class SubcategoryFilters {
  final bool hasMark;
  final bool hasModel;
  final List<Parameter> parameters;

  SubcategoryFilters(
    this.parameters, {
    required this.hasMark,
    required this.hasModel,
  });
}
