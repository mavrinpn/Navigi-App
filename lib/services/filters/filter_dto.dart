import 'package:appwrite/appwrite.dart';
import 'package:smart/models/item/item.dart';
import 'package:smart/services/parameters_parser.dart';

class DefaultFilterDto {
  String? text;
  String? lastId;
  String? sortBy;
  double? minPrice;
  double? maxPrice;
  double? radius;
  String? cityId;
  String? areaId;

  DefaultFilterDto({
    this.text = '',
    this.lastId,
    this.sortBy,
    this.minPrice,
    this.maxPrice,
    this.radius,
    this.cityId,
    this.areaId,
  });
}

class SubcategoryFilterDTO {
  String? text;
  String? lastId;
  String? mark;
  String? model;
  String? sortBy;
  double? minPrice;
  double? maxPrice;
  double? radius;
  String subcategory;
  List<Parameter> parameters;
  String? cityId;
  String? areaId;
  int? limit;
  String? excludeId;

  SubcategoryFilterDTO({
    this.text,
    this.lastId,
    this.sortBy,
    this.minPrice,
    this.maxPrice,
    this.radius,
    this.mark,
    this.model,
    this.cityId,
    this.areaId,
    this.limit,
    this.excludeId,
    required this.parameters,
    required this.subcategory,
  });

  DefaultFilterDto toDefaultFilter() => DefaultFilterDto(
        text: text,
        lastId: lastId,
        sortBy: sortBy,
        minPrice: minPrice,
        maxPrice: maxPrice,
        radius: radius,
      );

  List<dynamic> convertSelectedParametersToStringList(
      List<ParameterOption> parameters) {
    final result = [];

    for (var i in parameters) {
      result.add(i.key);
    }

    return result;
  }

  List<String> convertParametersToQuery() {
    final List<String> queries = [];
    for (final parameter in parameters) {
      if (parameter is InputParameter) {
        queries.add(Query.equal(parameter.key, parameter.currentValue));
      } else if (parameter is SelectParameter &&
          parameter.selectedVariants.isNotEmpty) {
        queries.add(Query.equal(parameter.key,
            convertSelectedParametersToStringList(parameter.selectedVariants)));
      }
      if (parameter is MinMaxParameter) {
        if (parameter.min != null) {
          queries.add(Query.greaterThanEqual(parameter.key, parameter.min));
        }
        if (parameter.max != null) {
          queries.add(Query.lessThanEqual(parameter.key, parameter.max));
        }
      }
    }

    return queries;
  }
}
