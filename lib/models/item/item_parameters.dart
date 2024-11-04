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
        'currentValue': parameter.selectedVariants.map((e) => e.toJson()).toList(),
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
        return ['${parameter.currentValue}'];
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

  Future<String> buildKeywordsString({
    required BuildContext context,
    required List<Parameter> addParameters,
    required String? title,
    required String? description,
    required String? markId,
    required String? modelId,
  }) async {
    final synonymsManager = RepositoryProvider.of<SynonymsManager>(context);
    final markModelManager = RepositoryProvider.of<MarkModelManager>(context);

    List<String> keywords = [];

    if (title != null) {
      final words = title.split(' ');
      keywords.addAll(words);
      for (final word in words) {
        final synonyms = await synonymsManager.loadSynonyms(word: word);
        keywords.addAll(synonyms);
      }
    }
    if (markId != null) {
      final markTitle = await markModelManager.getMarkNameById(markId);
      if (markTitle != null) {
        keywords.add(markTitle);
      }
    }

    if (modelId != null) {
      final modelTitle = await markModelManager.getModelNameById(modelId);
      if (modelTitle != null) {
        keywords.add(modelTitle);
      }
    }

    for (var element in addParameters) {
      keywords.addAll(parameterToList(element));
    }

    if (description != null) {
      keywords.addAll(description.split(' '));
    }

    keywords = keywords.map((e) {
      return e.toLowerCase().replaceAll('é', 'e').replaceAll('è', 'e');
    }).toList();
    keywords = keywords.toSet().toList();

    const arThe = 'ال';
    RegExp arabicRegExp = RegExp(r'[\u0600-\u06FF]');
    for (final keyword in [...keywords]) {
      if (!keyword.contains(arThe) && arabicRegExp.hasMatch(keyword)) {
        keywords.add('$keyword$arThe');
      }
    }

    String keywordsString = ' ${keywords.join(' ')} ';

    return keywordsString.length > 999 ? keywordsString.substring(0, 999) : keywordsString;
  }
}
