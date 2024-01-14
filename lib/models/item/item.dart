import 'dart:convert';

part 'item_parameters.dart';

part 'parameter.dart';

class SubcategoryItem {
  final String? id;
  final String _name;
  final String _subcategoryId;
  final Map<String, dynamic> _parameters;
  late ItemParameters _itemParameters;

  SubcategoryItem(
      {required String name,
      required this.id,
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

  SubcategoryItem.fromJson(Map<String, dynamic> json1)
      : _name = json1['name'] ?? '',
        id = json1['\$id'],
        _subcategoryId = json1['sub_category'] ?? '',
        _parameters = jsonDecode(json1['parametrs']);

  SubcategoryItem.withName(String name, String subCategory)
      : _name = name,
        _subcategoryId = subCategory,
        id = null,
        _parameters = {};

  void initialParameters() {
    _itemParameters = ItemParameters(
        staticParameters: _getStaticParameters(),
        variableParametersList: _getVariableParameters());
  }

  List<Parameter> _getVariableParameters() {
    List<Parameter> vp = [];

    _parameters.forEach((key, value) {
      if (value.runtimeType == List<dynamic>) {
        vp.add(Parameter(key: key, variants: value));
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
