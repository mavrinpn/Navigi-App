class KeyWord {
  final String id;
  final String subcategoryId;
  final String nameAr;
  final String nameFr;
  final String? type;
  final String? model;
  final String query;

  KeyWord({
    required this.id,
    required this.subcategoryId,
    required this.nameAr,
    required this.nameFr,
    required this.type,
    required this.model,
    required this.query,
  });

  factory KeyWord.fromJson(Map<String, dynamic> json) {
    return KeyWord(
      id: json['\$id'],
      subcategoryId: json['subcategory_id'] ?? '',
      nameAr: json['nameAr'] ?? '',
      nameFr: json['nameFr'] ?? '',
      type: json['type'],
      model: json['model'],
      query: json['query'] ?? '',
    );
  }
}
