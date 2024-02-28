import 'package:smart/models/item/item.dart';

class MarksFilter {
  final String markId;
  final String? modelId;
  final List<Parameter>? modelParameters;

  final String markTitle;
  final String modelTitle;

  MarksFilter({
    required this.markId,
    this.modelId,
    this.modelParameters,
    required this.markTitle,
    required this.modelTitle,
  });
}
