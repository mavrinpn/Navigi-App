import 'dart:convert';

import 'package:smart/models/item.dart';

class StaticParameters {
  final String _stringParameters;

  StaticParameters({required String parameters})
      : _stringParameters = parameters;

  List<VariableParameter> _getStaticParameters() {
    List<VariableParameter> sp = [];
    jsonDecode(_stringParameters).forEach((key, value) {
      sp.add(VariableParameter(key: key, variants: [value]));
    });
    return sp;
  }

  List<VariableParameter> get parameters => _getStaticParameters();
}