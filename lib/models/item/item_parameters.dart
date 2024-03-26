part of 'item.dart';

class ItemParameters {
  String parameterToJson(Parameter parameter) {
    if (parameter is SelectParameter) {
      final Map map = {
        'nameAr': parameter.arName,
        'nameFr': parameter.frName,
        'id': parameter.key,
        'type': 'option',
        'currentValue': parameter.currentValue.toJson()
      };
      return jsonEncode(map);
    }
    if (parameter is MultiSelectParameter) {
      final Map map = {
        'nameAr': parameter.arName,
        'nameFr': parameter.frName,
        'id': parameter.key,
        'type': 'multioption',
        'currentValue':
            parameter.selectedVariants.map((e) => e.toJson()).toList(),
      };
      return jsonEncode(map);
    }
    if (parameter is SingleSelectParameter) {
      final Map map = {
        'nameAr': parameter.arName,
        'nameFr': parameter.frName,
        'id': parameter.key,
        'type': 'singleoption',
        'currentValue': parameter.currentValue.toJson(),
      };
      return jsonEncode(map);
    }
    if (parameter is InputParameter) {
      final Map map = {
        'nameAr': parameter.arName,
        'nameFr': parameter.frName,
        'id': parameter.key,
        'type': 'number',
        'currentValue': parameter.currentValue
      };
      return jsonEncode(map);
    }
    if (parameter is TextParameter) {
      final Map map = {
        'nameAr': parameter.arName,
        'nameFr': parameter.frName,
        'id': parameter.key,
        'currentValue': parameter.currentValue
      };
      return jsonEncode(map);
    }
    return '';
  }

  String buildJsonFormatParameters({required List<Parameter> addParameters}) {
    String str = '[';
    for (int i = 0; i < addParameters.length; i++) {
      if (i != 0) {
        str += ', ';
      }
      str += parameterToJson(addParameters[i]);
    }
    str += ']';

    return str;
  }
}
