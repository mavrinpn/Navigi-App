class Subcategory {
  late final String id;
  late final String name;

  late final String nameFr;
  late final String nameAr;

  late final bool containsOther;
  late final String? categoryId;
  late final String? subcategoryId;

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
    required this.name,
    required this.id,
    required this.nameFr,
    required this.nameAr,
    this.containsOther = false,
  });

  Subcategory.fromJson(Map<String, dynamic> json) {
    categoryId = json['categorie_id'];
    name = json['name'];
    nameFr = json['nameFr'];
    nameAr = json['nameAr'];
    id = json['\$id'];
    containsOther = json['containsOther'] ?? false;
  }
}
