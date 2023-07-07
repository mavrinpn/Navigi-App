import 'dart:convert';

import 'package:smart/models/item/item.dart';

class StaticParameters {
  final String _stringParameters;

  StaticParameters({required String parameters})
      : _stringParameters = parameters;

  List<Parameter> _getStaticParameters() {
    List<Parameter> sp = [];
    jsonDecode(_stringParameters).forEach((key, value) {
      sp.add(Parameter(key: key, variants: [value]));
    });
    return sp;
  }

  List<Parameter> get parameters => _getStaticParameters();
}