part of 'item.dart';

abstract class Parameter {
  String get key;

  String get arName;

  String get frName;

  dynamic get currentValue;
}

class SelectParameter implements Parameter {
  @override
  final String key;
  @override
  final String arName;
  @override
  final String frName;

  String get name {
    final locale = currentLocaleShortName.value;
    return locale == 'fr' ? frName : arName;
  }

  @override
  ParameterOption currentValue;

  List<ParameterOption> variants;

  List<ParameterOption> selectedVariants = [];

  void addSelectedValue(dynamic value) => selectedVariants.add(value);

  void removeSelectedValue(dynamic value) => selectedVariants.remove(value);

  bool isSelected(ParameterOption value) => selectedVariants.contains(value);

  SelectParameter(
      {required this.key, required this.variants, ParameterOption? current, required this.arName, required this.frName})
      : currentValue = current ??
            variants.firstOrNull ??
            ParameterOption(
              'key',
              nameAr: 'nameAr',
              nameFr: 'nameFr',
            );

  @override
  String toString() => '"$key": "$currentValue"';

  void setVariant(dynamic value) {
    currentValue = value;
  }
}

class SingleSelectParameter implements Parameter {
  @override
  final String key;
  @override
  final String arName;
  @override
  final String frName;

  String get name {
    final locale = currentLocaleShortName.value;
    return locale == 'fr' ? frName : arName;
  }

  @override
  ParameterOption currentValue;

  List<ParameterOption> variants;

  List<ParameterOption> selectedVariants = [];

  void addSelectedValue(dynamic value) => selectedVariants.add(value);

  void removeSelectedValue(dynamic value) => selectedVariants.remove(value);

  bool isSelected(ParameterOption value) => selectedVariants.contains(value);

  SingleSelectParameter({
    required this.key,
    required this.variants,
    ParameterOption? current,
    required this.arName,
    required this.frName,
  }) : currentValue = current ??
            variants.firstOrNull ??
            ParameterOption(
              'key',
              nameAr: 'nameAr',
              nameFr: 'nameFr',
            );

  @override
  String toString() => '"$key": "$currentValue"';

  void setVariant(dynamic value) {
    currentValue = value;
  }
}

class MultiSelectParameter implements Parameter {
  @override
  final String key;
  @override
  final String arName;
  @override
  final String frName;

  String get name {
    final locale = currentLocaleShortName.value;
    return locale == 'fr' ? frName : arName;
  }

  @override
  ParameterOption currentValue;

  List<ParameterOption> variants;

  List<ParameterOption> selectedVariants = [];

  void addSelectedValue(dynamic value) => selectedVariants.add(value);

  void removeSelectedValue(dynamic value) => selectedVariants.remove(value);

  bool isSelected(ParameterOption value) => selectedVariants.contains(value);

  MultiSelectParameter({
    required this.key,
    required this.variants,
    ParameterOption? current,
    required this.arName,
    required this.frName,
  }) : currentValue = current ??
            variants.firstOrNull ??
            ParameterOption(
              'key',
              nameAr: 'nameAr',
              nameFr: 'nameFr',
            );

  @override
  String toString() => '"$key": "$currentValue"';

  void setVariant(dynamic value) {
    currentValue = value;
  }
}

class InputParameter implements Parameter {
  @override
  final String key;

  @override
  final String arName;
  @override
  final String frName;

  String get name {
    final locale = currentLocaleShortName.value;
    return locale == 'fr' ? frName : arName;
  }

  final String type;
  dynamic value;

  @override
  String toString() => '"$key": "$currentValue"';

  @override
  dynamic get currentValue => value;

  Map<String, dynamic> toJson() => {'id': key, 'nameAr': arName, 'nameFr': frName, 'value': currentValue};

  InputParameter(this.key, this.type, this.arName, this.frName);

  bool validValue(dynamic value) {
    if (type == 'int' && value.runtimeType is int) return true;
    if (type == 'double' && value.runtimeType is double) return true;
    if (type == 'String' && value.runtimeType is String) return true;

    return false;
  }
}

class MinMaxParameter implements Parameter {
  MinMaxParameter(
    this.key,
    this.arName,
    this.frName,
  );

  @override
  get currentValue => '$min - $max';

  int? min;
  int? max;

  @override
  final String key;

  @override
  final String arName;
  @override
  final String frName;

  String get name {
    final locale = currentLocaleShortName.value;
    return locale == 'fr' ? frName : arName;
  }
}

class TextParameter implements Parameter {
  @override
  final String key;
  @override
  final String arName;
  @override
  final String frName;

  String get name {
    final locale = currentLocaleShortName.value;
    return locale == 'fr' ? frName : arName;
  }

  String value;
  @override
  String get currentValue => value;

  Map<String, dynamic> toJson() => {'id': key, 'nameAr': arName, 'nameFr': frName, 'value': currentValue};

  TextParameter({
    required this.key,
    required this.arName,
    required this.frName,
    required this.value,
  });
}
