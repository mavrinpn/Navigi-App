class TipWord {
  final String id;
  final String subcategoryId;
  final String? previousWordId;
  final String? groupId;
  final String? previousWordGroupId;
  final String nameAr;
  final String nameFr;
  final String? mark;
  final String? model;
  final String? type;

  TipWord({
    required this.id,
    required this.subcategoryId,
    required this.previousWordId,
    required this.groupId,
    required this.previousWordGroupId,
    required this.nameAr,
    required this.nameFr,
    required this.mark,
    required this.model,
    required this.type,
  });

  factory TipWord.fromJson(Map<String, dynamic> json) {
    return TipWord(
      id: json['\$id'],
      subcategoryId: json['subcategory_id'] ?? '',
      previousWordId: json['previousWordId'],
      groupId: json['groupId'],
      previousWordGroupId: json['previousWordGroupId'],
      nameAr: json['nameAr'] ?? '',
      nameFr: json['nameFr'] ?? '',
      mark: json['mark'],
      model: json['model'],
      type: json['type'],
    );
  }
}
