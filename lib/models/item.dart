import 'dart:convert';
import 'dart:developer';

import 'package:smart/models/variable_paramets.dart';

class SubCategoryItem {
  String? name;
  String? subcategoryId;
  Map<String, dynamic>? parameters;
  late ItemParameters itemParameters;

  SubCategoryItem({required this.name, required this.subcategoryId, required this.parameters}) : super () {initialParameters();}

  void initialParameters() {
    itemParameters = ItemParameters(staticParameters: _getStaticParameters(), variableParametersList: _getVariableParameters());
  }

  SubCategoryItem.fromJson(Map<String, dynamic> json1) {
    name = json1['name'] ?? '';
    subcategoryId = json1['sub_category'] ?? '';
    final mapString = json1['parametrs'];
    parameters = jsonDecode(mapString);
  }

  SubCategoryItem.withName(String name,String subCategory) {
    name = name;
    subcategoryId = subCategory;
    parameters = {};
  }

  List<VariableParameter> _getVariableParameters() {
    List<VariableParameter> vp = [];

    parameters!.forEach((key, value) {
      if (value.runtimeType == List<dynamic>) {
        vp.add(VariableParameter(key: key, variants: value));
      }
    });
    return vp;
  }

  List<String> _getStaticParameters()
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
class ItemParameters {
  List<String> staticParameters;
  List<VariableParameter> variableParametersList;

  ItemParameters({required this.staticParameters, required this.variableParametersList});
}
