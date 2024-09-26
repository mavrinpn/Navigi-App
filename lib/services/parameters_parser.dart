import 'package:smart/main.dart';
import 'package:smart/models/item/item.dart';

class ParametersParser {
  final List encodedString;

  ParametersParser(this.encodedString, {bool useMinMax = false}) {
    initialize(useMinMax);
  }

  List<Parameter> decodedParameters = [];

  void initialize(bool useMinMax) {
    final List decode = encodedString;

    for (var json in decode) {
      if (json['type'] == 'option') {
        parseOptionParameter(json);
      }
      if (json['type'] == 'multioption') {
        parseMultiOptionParameter(json);
      }
      if (json['type'] == 'singleoption') {
        parseSingleOptionParameter(json);
      }
      if (json['type'] == 'number') {
        if (useMinMax) {
          parseMinMaxParameter(json);
        } else {
          parseInputParameter(json);
        }
      }
    }
  }

  void parseOptionParameter(Map json) {
    final List<ParameterOption> options = [];

    for (var optionJson in json['options']) {
      options.add(ParameterOption.fromJson(optionJson));
    }

    final parameter = SelectParameter(
      key: json['id'],
      variants: options,
      arName: json['nameAr'],
      frName: json['nameFr'] ?? '',
    );

    decodedParameters.add(parameter);
  }

  void parseMultiOptionParameter(Map json) {
    final List<ParameterOption> options = [];

    for (var optionJson in json['options']) {
      options.add(ParameterOption.fromJson(optionJson));
    }

    final parameter =
        MultiSelectParameter(key: json['id'], variants: options, arName: json['nameAr'], frName: json['nameFr']);

    decodedParameters.add(parameter);
  }

  void parseSingleOptionParameter(Map json) {
    final List<ParameterOption> options = [];

    for (var optionJson in json['options']) {
      options.add(ParameterOption.fromJson(optionJson));
    }

    final parameter =
        SingleSelectParameter(key: json['id'], variants: options, arName: json['nameAr'], frName: json['nameFr']);

    decodedParameters.add(parameter);
  }

  void parseInputParameter(Map json) {
    final parameter = InputParameter(json['id'], 'int', json['nameAr'], json['nameFr']);

    decodedParameters.add(parameter);
  }

  void parseMinMaxParameter(Map json) {
    final parameter = MinMaxParameter(json['id'], json['nameAr'], json['nameFr']);

    decodedParameters.add(parameter);
  }
}

class ParameterOption {
  final dynamic key;
  final String nameAr;
  final String nameFr;

  String get name {
    return currentLocaleShortName.value == 'fr' ? nameFr : nameAr;
  }

  ParameterOption(
    this.key, {
    required this.nameAr,
    required this.nameFr,
  });

  ParameterOption.fromJson(Map<String, dynamic> json)
      : key = json['id'],
        nameAr = json['nameAr'],
        nameFr = json['nameFr'];

  Map<String, dynamic> toJson() => {'id': key, 'nameAr': nameAr, 'nameFr': nameFr};

  @override
  bool operator ==(Object other) {
    if (other is ParameterOption) {
      return key == other.key;
    }
    return super == other;
  }

  @override
  int get hashCode => key.hashCode ^ nameAr.hashCode ^ nameFr.hashCode;
}
