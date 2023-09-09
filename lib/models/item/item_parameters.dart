part of 'item.dart';

class ItemParameters {
  List<String> staticParameters;
  List<Parameter> variableParametersList;

  ItemParameters({required this.staticParameters, required this.variableParametersList});

  String buildJsonFormatParameters() {
    String p;
    if (staticParameters.isNotEmpty) {
      p = staticParameters.join(', ');
    } else {
      p = '';
    }
    // print(staticParameters);
    // print(p);
    return '{$p${variableParametersList.join(', ')}}';
  }

  String getParametersValues () {
    List<String> values = [];

    for (var param in variableParametersList) {
      values.add(param.currentValue);
    }

    return values.join(' ');
  }
}