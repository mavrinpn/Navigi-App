import 'package:smart/models/item/item.dart';

class MarksFilter {
  final String markId;
  final String? modelId;
  final List<Parameter>? modelParameters;

  MarksFilter({
    required this.markId,
    this.modelId,
    this.modelParameters,
  });
}
