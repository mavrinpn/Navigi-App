class Subcategory {
  final String id;
  final String name;
  final String nameFr;
  final String nameAr;
  final bool containsOther;
  final String categoryId;
  final String subcategoryId;
  final int weight;

  String localizedName(String locale) {
    if (locale == 'fr') {
      return nameFr;
    } else if (locale == 'ar') {
      return nameAr;
    } else {
      return name;
    }
  }

  Subcategory({
    required this.categoryId,
    required this.subcategoryId,
    required this.name,
    required this.id,
    required this.nameFr,
    required this.nameAr,
    this.containsOther = false,
    required this.weight,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      categoryId: json['categoryId'],
      subcategoryId: json['subcategoryId'] ?? '',
      name: json['name'],
      id: json['\$id'],
      nameFr: json['nameFr'],
      nameAr: json['nameAr'],
      weight: int.tryParse('${json['weight']}') ?? 999,
      containsOther: json['containsOther'] ?? false,
    );
  }
}
