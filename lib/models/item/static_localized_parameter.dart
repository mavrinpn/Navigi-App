import 'package:smart/services/parameters_parser.dart';

abstract class StaticLocalizedParameter {
  String get key;

  String get nameAr;

  String get nameFr;

  String get valueAr;

  String get valueFr;
}

class SelectStaticParameter implements StaticLocalizedParameter {
  @override
  final String key;
  @override
  final String nameAr;
  @override
  final String nameFr;

  final ParameterOption currentOption;

  SelectStaticParameter(
      {required this.key,
      required this.nameFr,
      required this.nameAr,
      required this.currentOption});

  SelectStaticParameter.fromJson(Map<String, dynamic> json)
      : key = json['id'],
        nameAr = json['nameAr'],
        nameFr = json['nameFr'],
        currentOption = ParameterOption(json['currentValue']['id'],
            nameAr: json['currentValue']['nameAr'],
            nameFr: json['currentValue']['nameFr']);

  @override
  String get valueFr => currentOption.nameFr;

  @override
  String get valueAr => currentOption.nameAr;
}

List<ParameterOption> _parameterOption(List<dynamic> jsonList) {
  List<ParameterOption> result = [];
  for (final json in jsonList) {
    result.add(ParameterOption(json['id'],
        nameAr: json['nameAr'], nameFr: json['nameFr']));
  }
  return result;
}

class MultiSelectStaticParameter implements StaticLocalizedParameter {
  @override
  final String key;
  @override
  final String nameAr;
  @override
  final String nameFr;

  final List<ParameterOption> currentOption;

  MultiSelectStaticParameter({
    required this.key,
    required this.nameFr,
    required this.nameAr,
    required this.currentOption,
  });

  MultiSelectStaticParameter.fromJson(Map<String, dynamic> json)
      : key = json['id'],
        nameAr = json['nameAr'],
        nameFr = json['nameFr'],
        currentOption = _parameterOption(json['currentValue']);

  @override
  String get valueFr => currentOption.map((e) => e.nameFr).join(', ');

  @override
  String get valueAr => currentOption.map((e) => e.nameAr).join(', ');
}

class InputStaticParameter implements StaticLocalizedParameter {
  @override
  final String key;
  @override
  final String nameAr;
  @override
  final String nameFr;

  final dynamic value;

  InputStaticParameter(
      {required this.key,
      required this.nameFr,
      required this.nameAr,
      required this.value});

  InputStaticParameter.fromJson(Map<String, dynamic> json)
      : key = json['id'],
        nameAr = json['nameAr'],
        nameFr = json['nameFr'],
        value = json['currentValue'];

  @override
  String get valueFr => value.toString();

  @override
  String get valueAr => value.toString();
}
