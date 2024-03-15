import 'package:smart/models/announcement.dart';
import 'package:smart/models/item/item.dart';
import 'package:smart/models/item/static_parameters.dart';
import 'package:smart/utils/price_type.dart';

class AnnouncementEditData {
  final String id;
  final String subcollectionId;
  String title;
  String description;
  double price;
  PriceType priceType;
  ItemParameters? parameters;
  List<dynamic> images;

  AnnouncementEditData.fromAnnouncement(Announcement announcement)
      : id = announcement.id,
        subcollectionId = announcement.subcategoryId,
        title = announcement.title,
        description = announcement.description,
        images = announcement.images,
        price = announcement.price,
        priceType = announcement.priceType;

  mergeParameters(StaticParameters staticParameters) {
    for (var parameter in []) {
      for (var staticParameter in staticParameters.parameters) {
        if (parameter.key == staticParameter.key) {
          // parameter.setVariant(staticParameter.currentValue);
        }
      }
    }
  }

  Map<String, dynamic> toJson() => {
        'name': title,
        'description': description,
        'price': price,
        'price_type': priceType.name,
        'parametrs': parameters != null
            ? parameters!.buildJsonFormatParameters(addParameters: [])
            : "{}",
        'images': images,
      };
}
