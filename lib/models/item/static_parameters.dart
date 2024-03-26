import 'dart:convert';

import 'package:smart/models/item/static_localized_parameter.dart';

class StaticParameters {
  List<StaticLocalizedParameter> parameters = [];

  StaticParameters({required String encodedParameters}) {
    if (encodedParameters == '{}') {
      return;
    }
    final decode = jsonDecode(encodedParameters);

    parameters = [];
    for (var i in decode) {
      if (i['type'] == 'option') {
        parameters.add(SelectStaticParameter.fromJson(i));
      } else if (i['type'] == 'multioption') {
        parameters.add(MultiSelectStaticParameter.fromJson(i));
      } else if (i['type'] == 'singleoption') {
        parameters.add(SingleSelectStaticParameter.fromJson(i));
      } else {
        parameters.add(InputStaticParameter.fromJson(i));
      }
    }
  }
}
