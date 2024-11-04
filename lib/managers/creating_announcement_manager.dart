import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:map_kit_interface/map_kit.dart';
import 'package:rxdart/rxdart.dart';
import 'package:smart/feature/create_announcement/bloc/creating/creating_announcement_cubit.dart';
import 'package:smart/feature/create_announcement/data/models/car_filter.dart';
import 'package:smart/feature/create_announcement/data/models/marks_filter.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/models/item/item.dart';
import 'package:smart/models/item/subcategory_filters.dart';
import 'package:smart/services/database/database_service.dart';
import 'package:smart/utils/image_compress.dart';
import 'package:smart/utils/price_type.dart';

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

  bool isCreating = false;

  CreatingAnnouncementManager({required this.client})
      : dbService = DatabaseService(client: client),
        account = Account(client),
        storageManager = FileStorageManager(client: client);

  AnnouncementCreatingData creatingData = AnnouncementCreatingData();
  SubcategoryFilters? subcategoryFilters;

  MarksFilter? marksFilter;
  CarFilter? carFilter;

  SubcategoryItem? currentItem;
  List<XFile> images = [];

  CityDistrict? cityDistrict;
  CommonLatLng? customPosition;

  BehaviorSubject<LoadingStateEnum> creatingState = BehaviorSubject<LoadingStateEnum>.seeded(LoadingStateEnum.wait);

  String get prise => (creatingData.price ?? 0).toString();

  List<Parameter> getParametersList() {
    final parameters = <Parameter>[];
    parameters.addAll(subcategoryFilters?.parameters ?? []);

    if (carFilter != null) {
      parameters.addAll([carFilter!.dotation]);
      parameters.addAll([carFilter!.engine]);
    }

    if (marksFilter?.modelParameters != null) {
      parameters.addAll(marksFilter!.modelParameters!);
    }

    return parameters;
  }

  Future<List<XFile>> pickImages() async {
    final resImages = await _picker.pickMultiImage();

    images.addAll(resImages);

    // compressingImages = _compressImages(resImages);
    // compressingImages = _compressImages();
    return resImages;
  }

  Future<List<Uint8List>> compressImagesToBytes() async {
    List<Uint8List> imagesAsBytes = [];
    for (var image in images) {
      final bytes = await image.readAsBytes();
      final res = await resizeAndcompressImage(bytes);
      imagesAsBytes.add(res);
    }
    return imagesAsBytes;
  }

  Future<Uint8List> compressThumbToBytes() async {
    final bytes = await images.first.readAsBytes();
    final res = await resizeAndcompressThumb(bytes);
    return res;
  }

  // Future<void> _compressImages(List<XFile> images) async {
  //   for (var image in images) {
  //     final bytes = await image.readAsBytes();
  //     final res = await _compressImage(bytes);
  //     imagesAsBytes.add(res);
  //   }
  // }

  void setCategory(String categoryId) => creatingData.categoryId = categoryId;

  void setSubcategory(String subcategoryId) {
    creatingData.subcategoryId = subcategoryId;
  }

  void setType(bool type) => creatingData.type = type;

  void setItem(SubcategoryItem? newItem, {String? name, String? id}) {
    currentItem = newItem ?? SubcategoryItem.withName(name!, creatingData.subcategoryId!);

    creatingData.itemName = currentItem!.name;
    creatingData.itemId = currentItem!.id;
  }

  void setPlace(CityDistrict district) {
    // creatingData.placeId = district.id;
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

  void setDescription(String description) => creatingData.description = description;

  void setPrice(double price) => creatingData.price = price;
  void setPriceType(PriceType type) => creatingData.priceType = type;

  Future<void> _setParameters(BuildContext context) async {
    if (subcategoryFilters != null) {
      final List<Parameter> parameters = [];
      if (carFilter != null) {
        // if (subcategoryFilters!.hasMark) {
        //   parameters.add(
        //     TextParameter(
        //       key: 'car_mark',
        //       arName: 'العلامة التجارية',
        //       frName: 'Marque',
        //       value: carFilter!.markTitle,
        //     ),
        //   );
        // }
        // if (subcategoryFilters!.hasModel) {
        //   parameters.add(
        //     TextParameter(
        //       key: 'car_model',
        //       arName: 'نموذج',
        //       frName: 'Modèle',
        //       value: carFilter!.modelTitle,
        //     ),
        //   );
        // }
        parameters.add(carFilter!.dotation);
        parameters.add(carFilter!.engine);
      }

      if (marksFilter != null) {
        // if (subcategoryFilters!.hasMark) {
        //   parameters.add(
        //     TextParameter(
        //       key: 'mark',
        //       arName: 'العلامة التجارية',
        //       frName: 'Marque',
        //       value: marksFilter!.markTitle,
        //     ),
        //   );
        // }
        // if (subcategoryFilters!.hasModel) {
        //   parameters.add(
        //     TextParameter(
        //       key: 'model',
        //       arName: 'نموذج',
        //       frName: 'Modèle',
        //       value: marksFilter!.modelTitle,
        //     ),
        //   );
        // }
        //parameters.addAll(marksFilter!.modelParameters!);
      }

      String? markId;
      String? modelId;
      if (carFilter != null) {
        markId = carFilter?.markId;
        modelId = carFilter?.modelId;
      }

      if (marksFilter != null) {
        markId = marksFilter?.markId;
        if (marksFilter?.modelId != null) {
          modelId = marksFilter?.modelId;
        }
      }

      parameters.addAll(subcategoryFilters!.parameters);
      creatingData.parameters = ItemParameters().buildJsonFormatParameters(addParameters: parameters);
      creatingData.keywords = await ItemParameters().buildKeywordsString(
        context: context,
        addParameters: parameters,
        title: creatingData.title,
        description: creatingData.description,
        markId: markId,
        modelId: modelId,
      );
    }
  }

  String get buildTitle => currentItem!.title;

  void setTitle(String title) => creatingData.title = title;

  Future<void> setInfoFormItem(BuildContext context) async {
    await _setParameters(context);
  }

  void createAnnouncement(BuildContext context) async {
    creatingState.add(LoadingStateEnum.loading);
    try {
      final user = await account.get();
      final uid = user.$id;
      // await compressingImages;
      final imagesAsBytes = await compressImagesToBytes();
      final thumbAsBytes = await compressThumbToBytes();

      final List<String> urls = await uploadImages(imagesAsBytes);
      final String thumbUrl = await uploadThumb(thumbAsBytes);

      await dbService.announcements.createAnnouncement(
        context,
        uid,
        urls,
        thumbUrl,
        creatingData,
        getParametersList(),
        cityDistrict!,
        customPosition,
        marksFilter,
        carFilter,
      );

      clearAllData();
      creatingState.add(LoadingStateEnum.success);
    } catch (error) {
      creatingAnnouncementError = error.toString();
      creatingState.add(LoadingStateEnum.fail);
      rethrow;
    }
  }

  void clearAllData() {
    images.clear();
    creatingData.clear;
    // imagesAsBytes.clear();
    // compressingImages = null;
    currentItem = null;

    customPosition = null;
    specialOptions.clear();
    subcategoryFilters = null;
    marksFilter = null;
  }

  Future<List<String>> uploadImages(List<Uint8List> bytesList) async =>
      await storageManager.uploadAnnouncementImages(bytesList);

  Future<String> uploadThumb(Uint8List bytesList) async => await storageManager.uploadThumb(bytesList);
}
