class Subcategory {
  late final String id;
  late final String name;

  late final bool containsOther;
  late final String? categoryId;
  late final String? subcategoryId;

  String localizedName(String locale) {
    if (locale == 'fr') {
      return '';
    } else if (locale == 'ar') {
      return '';
    } else {
      return name;
    }
  }

  Subcategory(
      {required this.categoryId,
      required this.name,
      required this.id,
      this.containsOther = false});

  Subcategory.fromJson(Map<String, dynamic> json) {
    categoryId = json['categorie_id'];
    name = json['name'];
    id = json['\$id'];
    containsOther = json['containsOther'] ?? false;
  }
}
