class MediumPrice {
  final String id;
  final String brand;
  final String model;
  final String modification;
  final String engine;
  final int year;
  final int mileage;
  final int price;

  MediumPrice({
    required this.id,
    required this.brand,
    required this.model,
    required this.modification,
    required this.engine,
    required this.year,
    required this.mileage,
    required this.price,
  });

  factory MediumPrice.fromJson(Map<String, dynamic> json) {
    return MediumPrice(
      id: json['\$id'],
      brand: json['brand'],
      model: json['model'],
      modification: json['modification'],
      engine: json['engine'],
      year: json['year'] != null ? int.tryParse('${json['year']}') ?? 0 : 0,
      mileage:
          json['mileage'] != null ? int.tryParse('${json['mileage']}') ?? 0 : 0,
      price: json['price'] != null ? int.tryParse('${json['price']}') ?? 0 : 0,
    );
  }
}
