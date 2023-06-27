class Category {
  String? name;
  String? imageUrl;
  String? id;

  Category({required this.imageUrl, required this.name, required this.id});

  Category.fromJson(Map<String, dynamic> json) {
    imageUrl = json['image_url'];
    name = json['name'];
    id = json['\$id'];
  }
}
