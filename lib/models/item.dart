import 'dart:convert';
import 'dart:developer';

class SubCategoryItem {
  String? name;
  String? subcategoryId;
  Map<String, dynamic>? parameters;

  SubCategoryItem({required this.name, required this.subcategoryId, required this.parameters});

  SubCategoryItem.fromJson(Map<String, dynamic> json1) {
    name = json1['name'] ?? '';
    subcategoryId = json1['sub_category'] ?? '';
    final mapString = json1['parametrs'];
    parameters = jsonDecode(mapString);
  }

  List<VariableParameter> getVariableParameters() {
    List<VariableParameter> vp = [];

    parameters!.forEach((key, value) {
      if (value.runtimeType == List<dynamic>) {
        vp.add(VariableParameter(key: key, variants: value));
      }
    });
    return vp;
  }

  List<String> getStaticParameters()
  {
    List<String> sp = [];
    parameters!.forEach((key, value) {
      if (value.runtimeType != List<dynamic>) {
        sp.add('"$key": ${value.runtimeType != String ? value : '"$value"'}');
      }
    });
    return sp;
  }
}

class VariableParameter {
  String key;
  List variants;

  VariableParameter({required this.key, required this.variants});

  @override
  String toString() => '$key: $variants';

  String toJsonParameter(dynamic value) =>
      '"$key": ${value.runtimeType != String ? value : '"$value"'}';
}

class ItemParameters {
  String staticParameters;
  String? variableParameters;

  ItemParameters({required this.staticParameters, this.variableParameters});
}