import 'package:smart/models/item/item.dart';
import 'package:smart/services/parameters_parser.dart';

class AutoFilter {
  final String markId;
  final String modelId;
  final List<ParameterOption> complectations;
  final List<ParameterOption> engines;

  AutoFilter(
      this.markId, this.modelId, List stringDotations, List stringEngines)
      : complectations = List.generate(
            stringDotations.length,
            (index) => ParameterOption(stringDotations[index],
                nameAr: stringDotations[index],
                nameFr: stringDotations[index])),
        engines = List.generate(
            stringEngines.length,
            (index) => ParameterOption(stringEngines[index],
                nameAr: stringEngines[index], nameFr: stringEngines[index]));

  SelectParameter get dotation => SelectParameter(
      key: 'Dotation',
      variants: complectations,
      arName: 'مجموعة كاملة',
      frName: 'Dotation');

  SelectParameter get engine => SelectParameter(
      key: 'engines', variants: engines, arName: 'المحرك', frName: 'Moteur');
}
