import 'dart:convert';

class StaticParameters {
  final String _stringParameters;

  StaticParameters({required String parameters})
      : _stringParameters = parameters;

  List<Map<String, String>> _getStaticParameters() {
    List<Map<String, String>> sp = [];
    jsonDecode(_stringParameters).forEach((key, value) {
      sp.add({'$key': '$value'});
    });
    return sp;
  }

  List<Map<String, String>> get parameters => _getStaticParameters();
}