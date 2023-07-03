import 'dart:convert';

part 'item_parameters.dart';

part 'variable_parameters.dart';

class SubCategoryItem {
  final String _name;
  final String _subcategoryId;
  final Map<String, dynamic> _parameters;
  late ItemParameters _itemParameters;

  SubCategoryItem(
      {required String name,
      required String subcategoryId,
      required Map<String, dynamic> parameters})
      : _parameters = parameters,
        _subcategoryId = subcategoryId,
        _name = name,
        super() {
    initialParameters();
  }

  String get name => _name;

  String get subcategory => _subcategoryId;

  ItemParameters get parameters => _itemParameters;

  String get title => '$_name ${_itemParameters.getParametersValues()}';

  SubCategoryItem.fromJson(Map<String, dynamic> json1)
      : _name = json1['name'] ?? '',
        _subcategoryId = json1['sub_category'] ?? '',
        _parameters = jsonDecode(json1['parametrs']);

  SubCategoryItem.withName(String name, String subCategory)
      : _name = name,
        _subcategoryId = subCategory,
        _parameters = {};

  void initialParameters() {
    _itemParameters = ItemParameters(
        staticParameters: _getStaticParameters(),
        variableParametersList: _getVariableParameters());
  }

  List<VariableParameter> _getVariableParameters() {
    List<VariableParameter> vp = [];

    _parameters.forEach((key, value) {
      if (value.runtimeType == List<dynamic>) {
        vp.add(VariableParameter(key: key, variants: value));
      }
    });
    return vp;
  }

  List<String> _getStaticParameters() {
    List<String> sp = [];
    _parameters.forEach((key, value) {
      if (value.runtimeType != List<dynamic>) {
        sp.add('"$key": ${value.runtimeType != String ? value : '"$value"'}');
      }
    });
    return sp;
  }
}
