import 'dart:io';

class CreatingData {
  String? categoryId;
  String? subcategoryId;
  String? title;
  String? description;
  List<File>? images;
  bool? type;
  double? price;
  String? itemName;
  String? parameters;
  String? placeId = 'aboba';


  @override
  String toString() {
    return 'category: $categoryId, \nsubcategory: $subcategoryId, \ndescription: $description, \ntype: $type, \nprice: $price \nparameters: $parameters';
  }

  Map<String, dynamic> toJason(String creatorId) =>
      {
        'name': title,
        'description': description,
        'type': type,
        'price': price,
        'item_name': itemName,
        'parametrs': parameters != '{, }' ? parameters : '{}',
        'creator_id': creatorId,
        'place_id': placeId,
      };

  void clear () {
    categoryId = null;
    subcategoryId = null;
    title = null;
    description = null;
    images = null;
    type = null;
    price = null;
    itemName = null;
    parameters = null;
    placeId = 'aboba';
  }
}