import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:smart/feature/create_announcement/data/models/car_filter.dart';
import 'package:smart/feature/create_announcement/data/models/marks_filter.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/models/item/subcategory_filters.dart';
import 'package:smart/services/database/database_service.dart';

import '../../models/announcement_creating_data.dart';
import '../../models/models.dart';
import '../enum/enum.dart';
import '../services/storage_service.dart';

enum SpecialAnnouncementOptions { customPlace, auto }

class CreatingAnnouncementManager {
  final Client client;
  final DatabaseService dbService;
  final FileStorageManager storageManager;
  final Account account;
  final _picker = ImagePicker();

  final List<SpecialAnnouncementOptions> specialOptions = [];

  CreatingAnnouncementManager({required this.client})
      : dbService = DatabaseService(client: client),
        account = Account(client),
        storageManager = FileStorageManager(client: client);

  AnnouncementCreatingData creatingData = AnnouncementCreatingData();
  SubcategoryFilters? subcategoryFilters;
  MarksFilter? marksFilter;

  SubcategoryItem? currentItem;
  List<XFile> images = [];
  List<Uint8List> imagesAsBytes = [];
  Future? compressingImages;

  CityDistrict? cityDistrict;
  LatLng? customPosition;

  CarFilter? carFilter;

  BehaviorSubject<LoadingStateEnum> creatingState =
      BehaviorSubject<LoadingStateEnum>.seeded(LoadingStateEnum.wait);

  String get prise => (creatingData.price ?? 0).toString();

  List<Parameter> getParametersList() {
    final parameters = <Parameter>[];
    parameters.addAll(subcategoryFilters!.parameters);

    if (carFilter != null) {
      parameters.add(carFilter!.dotation);
      parameters.add(carFilter!.engine);
    }

    if (marksFilter?.modelParameters != null) {
      parameters.addAll(marksFilter!.modelParameters!);
    }

    return parameters;
  }

  Future<List<XFile>> pickImages() async {
    final resImages = await _picker.pickMultiImage();

    images.addAll(resImages);

    compressingImages = _compressImages(resImages);
    return resImages;
  }

  Future<void> _compressImages(List<XFile> images) async {
    for (var image in images) {
      final bytes = await image.readAsBytes();
      final res = await _compressImage(bytes);
      imagesAsBytes.add(res);
    }
  }

  Future<Uint8List> _compressImage(Uint8List list) async =>
      await FlutterImageCompress.compressWithList(
        list,
        minWidth: 400,
        quality: 96,
      );

  void setCategory(String categoryId) => creatingData.categoryId = categoryId;

  void setSubcategory(String subcategoryId) {
    creatingData.subcategoryId = subcategoryId;
  }

  void setType(bool type) => creatingData.type = type;

  void setItem(SubcategoryItem? newItem, {String? name, String? id}) {
    currentItem =
        newItem ?? SubcategoryItem.withName(name!, creatingData.subcategoryId!);

    creatingData.itemName = currentItem!.name;
    creatingData.itemId = currentItem!.id;
  }

  void setPlace(CityDistrict district) {
    creatingData.placeId = district.id;
    creatingData.cityId = district.cityId;
    creatingData.areaId = district.id;
    cityDistrict = district;
  }

  void setImages(List<XFile> images) {
    creatingData.images = images.map((e) => e.path).toList();
  }

  void clearSpecifications() {
    carFilter = null;
    customPosition = null;
    specialOptions.clear();
  }

  void setDescription(String description) =>
      creatingData.description = description;

  void setPrice(String price) => creatingData.price = double.parse(price);

  void _setParameters() => creatingData.parameters = ItemParameters()
      .buildJsonFormatParameters(addParameters: subcategoryFilters!.parameters);

  String get buildTitle => currentItem!.title;

  void setTitle(String title) => creatingData.title = title;

  void setInfoFormItem() {
    _setParameters();
  }

  void createAnnouncement() async {
    creatingState.add(LoadingStateEnum.loading);
    try {
      final user = await account.get();
      final uid = user.$id;
      await compressingImages;
      final List<String> urls = await uploadImages(imagesAsBytes);

      await dbService.announcements.createAnnouncement(
        uid,
        urls,
        creatingData,
        getParametersList(),
        cityDistrict!,
        customPosition,
        marksFilter,
        carFilter,
      );

      clearAllData();
      creatingState.add(LoadingStateEnum.success);
    } catch (e) {
      creatingState.add(LoadingStateEnum.fail);
      rethrow;
    }
  }

  void clearAllData() {
    images.clear();
    creatingData.clear;
    imagesAsBytes.clear();
    compressingImages = null;
    currentItem = null;

    customPosition = null;
    specialOptions.clear();
    subcategoryFilters = null;
    marksFilter = null;
  }

  Future<List<String>> uploadImages(List<Uint8List> bytesList) async =>
      await storageManager.uploadAnnouncementImages(bytesList);
}
