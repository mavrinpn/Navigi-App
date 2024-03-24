import 'package:smart/models/item/item.dart';
import 'package:smart/services/parameters_parser.dart';

_stringDotations(List stringDotations) {
  return List.generate(
    stringDotations.length,
    (index) => ParameterOption(
      stringDotations[index]['id'],
      nameAr: stringDotations[index]['nameAr'],
      nameFr: stringDotations[index]['nameFr'],
    ),
  );
}

_stringEngines(List stringEngines) {
  return List.generate(
    stringEngines.length,
    (index) => ParameterOption(
      stringEngines[index]['id'],
      nameAr: stringEngines[index]['nameAr'],
      nameFr: stringEngines[index]['nameFr'],
    ),
  );
}

class CarFilter {
  final String markId;
  final String modelId;
  final List<ParameterOption> complectations;
  final List<ParameterOption> engines;

  final String markTitle;
  final String modelTitle;

  late SelectParameter dotation;
  late SelectParameter engine;

  CarFilter({
    required this.markId,
    required this.modelId,
    required this.markTitle,
    required this.modelTitle,
    required List stringDotations,
    required List stringEngines,
  })  : complectations = _stringDotations(stringDotations),
        engines = _stringEngines(stringEngines),
        dotation = SelectParameter(
            key: 'complectation',
            variants: _stringDotations(stringDotations),
            arName: 'مجموعة كاملة',
            frName: 'Dotation'),
        engine = SelectParameter(
          key: 'engine',
          variants: _stringEngines(stringEngines),
          arName: 'المحرك',
          frName: 'Moteur',
        );

  // SelectParameter get dotation => SelectParameter(
  //     // key: 'Dotation',
  //     key: 'complectation',
  //     variants: complectations,
  //     arName: 'مجموعة كاملة',
  //     frName: 'Dotation');

  // SelectParameter get engine => SelectParameter(
  //       // key: 'engines',
  //       key: 'engine',
  //       variants: engines,
  //       arName: 'المحرك',
  //       frName: 'Moteur',
  //     );
}
