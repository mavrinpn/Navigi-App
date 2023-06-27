class SubCategory{
  String? name;
  String? categoryId;
  String? id;

  SubCategory({required this.categoryId, required this.name, required this.id});

  SubCategory.fromJson(Map<String, dynamic> json) {
    categoryId = json['categorie_id'];
    name = json['name'];
    id = json['\$id'];
  }
}