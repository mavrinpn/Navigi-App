import 'package:smart/models/announcement.dart';
import 'package:smart/models/item/item.dart';
import 'package:smart/models/item/static_parameters.dart';
import 'package:smart/utils/price_type.dart';

class AnnouncementEditData {
  final String id;
  final String subcollectionId;
  String title;
  String cityId;
  String areaId;
  CityDistrict area;
  String description;
  double price;
  PriceType priceType;
  StaticParameters staticParameters;
  List<Parameter> parameters;
  List<dynamic> images;
  String thumb;
  String modelId;
  String markId;
  double longitude;
  double latitude;

  AnnouncementEditData.fromAnnouncement(Announcement announcement)
      : id = announcement.anouncesTableId,
        subcollectionId = announcement.subcategoryId,
        title = announcement.title,
        description = announcement.description,
        cityId = announcement.area.cityId,
        areaId = announcement.area.id,
        area = announcement.area,
        images = announcement.images,
        thumb = announcement.thumb,
        price = announcement.price,
        priceType = announcement.priceType,
        staticParameters = announcement.staticParameters,
        modelId = announcement.model,
        markId = announcement.mark,
        longitude = announcement.longitude,
        latitude = announcement.latitude,
        parameters = [];

  // mergeParameters(StaticParameters staticParameters) {
  //   for (var parameter in []) {
  //     for (var staticParameter in staticParameters.parameters) {
  //       if (parameter.key == staticParameter.key) {
  //         // parameter.setVariant(staticParameter.currentValue);
  //       }
  //     }
  //   }
  // }

  Map<String, dynamic> toJson(
    String newSubcollectionId,
    String? newMarkId,
    String? newModelId,
    List<Parameter> parametersWithMarkAndModel,
  ) =>
      {
        'name': title,
        'description': description,
        'city_id': cityId,
        'area_id': areaId,
        'city': cityId,
        'area2': areaId,
        'price': price,
        'price_type': priceType.name,
        'parametrs': ItemParameters().buildJsonFormatParameters(
            addParameters: parametersWithMarkAndModel),
        'keywords': ItemParameters().buildListFormatParameters(
          addParameters: parametersWithMarkAndModel,
          title: title,
        ),
        'images': images,
        'thumb': thumb,
        'mark': newMarkId ?? markId,
        'model': newModelId ?? modelId,
        'subcategoryId': newSubcollectionId,
        'longitude': longitude,
        'latitude': latitude,
      };
}
