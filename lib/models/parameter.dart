part of 'item.dart';

class Parameter {
  String key;
  List variants;
  String currentValue;

  Parameter({required this.key, required this.variants}) : currentValue = variants[0].toString();

  @override
  String toString() => '"$key": "$currentValue"';

  void setVariant(String value) => currentValue = value;
}
