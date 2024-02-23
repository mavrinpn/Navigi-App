import 'dart:convert';

import 'package:smart/models/item/item.dart';

class ParametersParser {
  final List encodedString;

  ParametersParser(this.encodedString) {
    initialize();
  }

  List<Parameter> decodedParameters = [];

  void initialize() {
    final List decode = encodedString;

    print(decode.length);

    for (var json in decode) {
      print(json['type']);

      if (json['type'] == 'option') parseOptionParameter(json);
      if (json['type'] == 'number') parseInputParameter(json);
    }

    print('decoded parameters length: ${decodedParameters.length}');
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
        frName: json['nameFr']);

    print('fr: ${parameter.frName} ar: ${parameter.arName}');

    decodedParameters.add(parameter);
    print('decoded parameters length: ${decodedParameters.length}');
  }

  void parseInputParameter(Map json) {
    final parameter =
        InputParameter(json['id'], 'int', json['nameAr'], json['nameFr']);

    decodedParameters.add(parameter);
  }
}

class ParameterOption {
  final dynamic key;
  final String nameAr;
  final String nameFr;

  ParameterOption(this.key, {required this.nameAr, required this.nameFr});

  ParameterOption.fromJson(Map<String, dynamic> json)
      : key = json['id'],
        nameAr = json['nameAr'],
        nameFr = json['nameFr'];

  Map<String, dynamic> toJson() => {
    'id': key,
    'nameAr': nameAr,
    'nameFr': nameFr
  };

  @override
  bool operator ==(Object other) {
    if (other is ParameterOption) {
      return key == other.key;
    }
    return super == other;
  }
}
