import 'package:smart/models/announcement.dart';
import 'package:smart/models/item/item.dart';
import 'package:smart/models/item/static_parameters.dart';

class AnnouncementEditData {
  final String id;
  String title;
  String description;
  double price;
  ItemParameters? parameters;
  List<dynamic> images;

  AnnouncementEditData.fromAnnouncement(Announcement announcement)
      : id = announcement.id,
        title = announcement.title,
        description = announcement.description,
        images = announcement.images,
        price = announcement.price;

  mergeParameters(StaticParameters staticParameters) {
    for (var parameter in parameters!.variableParametersList) {
      for (var staticParameter in staticParameters.parameters) {
        if (parameter.key == staticParameter.key) {
          parameter.setVariant(staticParameter.currentValue);
        }
      }
    }
  }

  Map<String, dynamic> toJson() => {
        'name': title,
        'description': description,
        'price': price,
        'parametrs':
            parameters != null ? parameters!.buildJsonFormatParameters() : "{}",
        'images': images,
      };
}
