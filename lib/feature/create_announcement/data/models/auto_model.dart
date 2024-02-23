import 'dart:convert';

class AutoModel {
  final String id;
  final String name;
  final List variants;
  final List engines;

  AutoModel(this.id, this.name, String encodedVariants, String encodedEngines)
      : variants = jsonDecode(encodedVariants), engines = jsonDecode(encodedEngines);
}
