class AnnouncementCreatingData {
  String? categoryId;
  String? subcategoryId;
  String? title;
  String? description;
  List<String>? images;
  bool? type;
  double? price;
  String? itemName;
  String? itemId;
  String? parameters;
  String? placeId;


  @override
  String toString() {
    return 'category: $categoryId, \nsubcategory: $subcategoryId, \ndescription: $description, \ntype: $type, \nprice: $price \nparameters: $parameters';
  }

  Map<String, dynamic> toJson(String creatorId, List<String> urls) =>
      {
        'name': title,
        'description': description,
        'type': type,
        'price': price,
        'item_name': itemName,
        'parametrs': parameters,
        'creator_id': creatorId,
        'images': urls,
        'creator': creatorId,
        'place': placeId,
        if (subcategoryId != null) 'subcategoryId': subcategoryId,
        if (itemId != null) 'itemId': itemId
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
    placeId = null;
  }
}