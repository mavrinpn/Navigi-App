class City {
  final String id;
  final String name;

  City.fromJson(Map<String, dynamic> json)
      : id = json['\$id'],
        name = json['name'];
}
