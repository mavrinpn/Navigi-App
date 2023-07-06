class Subcategory{
  String? name;
  String? categoryId;
  String? id;

  Subcategory({required this.categoryId, required this.name, required this.id});

  Subcategory.fromJson(Map<String, dynamic> json) {
    categoryId = json['categorie_id'];
    name = json['name'];
    id = json['\$id'];
  }
}