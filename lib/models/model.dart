class Model {
  final String id;
  final String name;
  final String manufacturerId;
  final String subcategoryId;
  final String parameters;

  Model({
    required this.id,
    required this.name,
    required this.manufacturerId,
    required this.subcategoryId,
    required this.parameters,
  });

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      id: json['\$id'],
      name: json['name'],
      manufacturerId: json['manufacturerId'],
      subcategoryId: json['subcategoryId'],
      parameters: json['parameters'],
    );
  }
}
