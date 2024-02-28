import 'dart:convert';

import 'package:smart/models/item/item.dart';
import 'package:smart/services/parameters_parser.dart';

class MarkModel {
  final String id;
  final String name;
  late final List<Parameter>? parameters;

  MarkModel(this.id, this.name, String? encodedParameters) {
    if (encodedParameters == null) {
      parameters = null;
    } else {
      try {
        //TODO remove replaceAll
        final result =
            jsonDecode(encodedParameters.replaceAll("'", '"')) as List;
        parameters = ParametersParser(result).decodedParameters;
      } catch (err) {
        parameters = null;
      }
    }
  }
}
