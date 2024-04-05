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

  List<String> parameterToList(Parameter parameter) {
    if (parameter is SelectParameter) {
      return [
        parameter.currentValue.nameAr,
        parameter.currentValue.nameFr,
      ];
    }
    if (parameter is MultiSelectParameter) {
      return [
        ...parameter.selectedVariants.map((e) => e.nameAr),
        ...parameter.selectedVariants.map((e) => e.nameFr),
      ];
    }
    if (parameter is SingleSelectParameter) {
      return [
        parameter.currentValue.nameAr,
        parameter.currentValue.nameFr,
      ];
    }
    if (parameter is InputParameter) {
      if (parameter.currentValue != null) {
        return [parameter.currentValue];
      }
    }
    if (parameter is TextParameter) {
      return [parameter.currentValue];
    }
    return [];
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

  String buildListFormatParameters({
    required List<Parameter> addParameters,
    required String? title,
  }) {
    List<String> params = [];
    if (title != null) {
      params.addAll(title.split(' '));
    }
    for (var element in addParameters) {
      params.addAll(parameterToList(element));
    }

    params = params.map((e) => e.toLowerCase()).toList();
    params = params.toSet().toList();

    return params.join(' ');
  }
}
