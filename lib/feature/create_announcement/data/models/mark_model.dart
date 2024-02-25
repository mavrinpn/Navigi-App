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
      parameters =
          ParametersParser(jsonDecode(encodedParameters)).decodedParameters;
    }
  }
}
