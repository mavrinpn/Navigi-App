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
