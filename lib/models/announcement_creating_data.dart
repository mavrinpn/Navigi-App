import 'package:smart/utils/price_type.dart';

class AnnouncementCreatingData {
  String? categoryId;
  String? subcategoryId;
  String? title;
  String? description;
  List<String>? images;
  bool? type;
  double? price;
  PriceType? priceType;
  String? itemName;
  String? itemId;
  String? parameters;
  String? keywords;
  String? cityId;
  String? areaId;

  @override
  String toString() {
    return 'category: $categoryId, \nsubcategory: $subcategoryId, \ndescription: $description, \ntype: $type, \nprice: $price \nparameters: $parameters';
  }

  Map<String, dynamic> toJson(String creatorId, List<String> urls) => {
        'name': itemName, //title,
        'description': description,
        'type': type,
        'price': price,
        'price_type': priceType?.name ?? 'dzd',
        'item_name': itemName,
        'parametrs': parameters,
        'keywords': keywords,
        'creator_id': creatorId,
        'images': urls,
        'creator': creatorId,
        'area2': areaId,
        'city': cityId,
        'city_id': cityId,
        'area_id': areaId,
        if (subcategoryId != null) 'subcategoryId': subcategoryId,
        if (itemId != null) 'itemId': itemId
      };

  void clear() {
    categoryId = null;
    subcategoryId = null;
    title = null;
    description = null;
    images = null;
    type = null;
    price = null;
    priceType = null;
    itemName = null;
    parameters = null;
    cityId = null;
    areaId = null;
  }
}
