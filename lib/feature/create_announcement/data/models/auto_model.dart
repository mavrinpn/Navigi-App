import 'dart:convert';

class CarModel {
  final String id;
  final String name;
  final List variants;
  final List engines;

  CarModel(
    this.id,
    this.name,
    String encodedVariants,
    String encodedEngines,
  )   : variants = jsonDecode(encodedVariants),
        engines = jsonDecode(encodedEngines);
}
