class VariableParameter {
  String key;
  List variants;
  String currentValue;

  VariableParameter({required this.key, required this.variants}) : currentValue = variants[0].toString();

  @override
  String toString() => '"$key": "$currentValue"';

  void setVariant(String value) => currentValue = value;
}
