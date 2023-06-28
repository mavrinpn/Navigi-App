class VariableParameters {
  String key;
  List variants;

  VariableParameters({required this.key, required this.variants});

  @override
  String toString() => '$key: $variants';

  String toJsonParameter(dynamic value) =>
      '"$key": ${value.runtimeType != String ? value : '"$value"'}';
}