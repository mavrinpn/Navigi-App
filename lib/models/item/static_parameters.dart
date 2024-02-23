import 'dart:convert';

import 'package:smart/models/item/item.dart';
import 'package:smart/models/item/static_localized_parameter.dart';
import 'package:smart/services/parameters_parser.dart';

class StaticParameters {
  late final List<StaticLocalizedParameter> parameters;

  StaticParameters({required String encodedParameters}) {
    final decode = jsonDecode(encodedParameters);
    parameters = [];
    for (var i in decode) {
      if (i['type'] == 'option') {
        parameters.add(SelectStaticParameter.fromJson(i));
      } else {
        parameters.add(InputStaticParameter.fromJson(i));
      }
    }
  }
}
