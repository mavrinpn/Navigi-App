import 'package:smart/models/item/item.dart';
import 'package:smart/services/parameters_parser.dart';

class CarFilter {
  final String markId;
  final String modelId;
  final List<ParameterOption> complectations;
  final List<ParameterOption> engines;

  final String markTitle;
  final String modelTitle;

  CarFilter({
    required this.markId,
    required this.modelId,
    required this.markTitle,
    required this.modelTitle,
    required List stringDotations,
    required List stringEngines,
  })  : complectations = List.generate(
          stringDotations.length,
          (index) => ParameterOption(
            stringDotations[index]['id'],
            nameAr: stringDotations[index]['nameAr'],
            nameFr: stringDotations[index]['nameFr'],
          ),
        ),
        engines = List.generate(
          stringEngines.length,
          (index) => ParameterOption(
            stringEngines[index]['id'],
            nameAr: stringEngines[index]['nameAr'],
            nameFr: stringEngines[index]['nameFr'],
          ),
        );

  SelectParameter get dotation => SelectParameter(
      // key: 'Dotation',
      key: 'complectation',
      variants: complectations,
      arName: 'مجموعة كاملة',
      frName: 'Dotation');

  SelectParameter get engine => SelectParameter(
        // key: 'engines',
        key: 'engine',
        variants: engines,
        arName: 'المحرك',
        frName: 'Moteur',
      );
}
