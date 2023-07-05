part of 'item.dart';

class ItemParameters {
  List<String> staticParameters;
  List<Parameter> variableParametersList;

  ItemParameters({required this.staticParameters, required this.variableParametersList});

  String buildJsonFormatParameters() {
    return '{${staticParameters.join(', ')}, ${variableParametersList.join(', ')}}';
  }

  String getParametersValues () {
    List<String> values = [];

    for (var param in variableParametersList) {
      values.add(param.currentValue);
    }

    return values.join(' ');
  }
}