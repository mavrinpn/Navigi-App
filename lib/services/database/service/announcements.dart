part of '../database_service.dart';

class AnnouncementsService {
  final Databases _databases;
  final Storage _storage;

  static const String activeAttribute = 'active';

  AnnouncementsService(Databases databases, Storage storage)
      : _databases = databases,
        _storage = storage;

  Future<List<Announcement>> getAnnouncements({
    required String? lastId,
    required String? excudeUserId,
  }) async {
    List<String> queries = ParametersFilterBuilder.getQueriesForGet(lastId);

    if (excudeUserId != null) {
      queries.add(Query.notEqual('creator_id', excudeUserId));
    }

    final res = await _databases.listDocuments(
      databaseId: mainDatabase,
      collectionId: postCollection,
      queries: queries,
    );

    List<Announcement> newAnnounces =
        announcementsFromDocuments(res.documents, _storage);

    return newAnnounces;
  }

  Future<List<Announcement>> searchLimitAnnouncements(
      DefaultFilterDto filterData) async {
    List<String> queries = ParametersFilterBuilder.getSearchQueries(filterData);

    if ((filterData.radius ?? 0) != 0) {
      queries.addAll(
          await LocationFilter.getLocationFilterForRadius(filterData.radius!));
    }

    if (filterData.cityId != null) {
      queries.add(Query.equal('city_id', filterData.cityId));
    }

    if (filterData.areaId != null) {
      queries.add(Query.equal('area_id', filterData.areaId));
    }

    final res = await _databases.listDocuments(
      databaseId: mainDatabase,
      collectionId: postCollection,
      queries: queries,
    );

    List<Announcement> newAnnounces =
        announcementsFromDocuments(res.documents, _storage);

    return newAnnounces;
  }

  Future<List<Announcement>> searchAnnouncementsInSubcategory(
      SubcategoryFilterDTO filterData) async {
    List<String> queries = ParametersFilterBuilder.getSearchQueries(
      filterData.toDefaultFilter(),
      subcategory: true,
    );

    queries.addAll(filterData.convertParametersToQuery());

    if ((filterData.radius ?? 0) != 0) {
      queries.addAll(
          await LocationFilter.getLocationFilterForRadius(filterData.radius!));
    }

    if (filterData.mark != null) {
      queries.add(Query.equal('mark', filterData.mark));
    }

    if (filterData.model != null) {
      queries.add(Query.equal('model', filterData.model));
    }

    if (filterData.cityId != null) {
      queries.add(Query.equal('city_id', filterData.cityId));
    }

    if (filterData.areaId != null) {
      queries.add(Query.equal('area_id', filterData.areaId));
    }

    if (filterData.limit != null) {
      queries.add(Query.limit(filterData.limit!));
    }

    if (filterData.excludeId != null) {
      queries.add(Query.notEqual('announcements', filterData.excludeId));
    }

    final res = await _databases.listDocuments(
      databaseId: mainDatabase,
      collectionId: filterData.subcategory,
      queries: queries,
    );

    List<Announcement> newAnnounces = [];

    for (var doc in res.documents) {
      if (doc.data['announcements'] != null) {
        Future<Uint8List> futureBytes = Future.value(Uint8List.fromList([]));
        if (doc.data['announcements']['images'] != null) {
          final id = getIdFromUrl(doc.data['announcements']['images'][0]);

          futureBytes = _storage.getFileView(
            bucketId: announcementsBucketId,
            fileId: id,
          );
        }

        final ann = Announcement.fromJson(
          json: doc.data['announcements'],
          futureBytes: futureBytes,
        );
        newAnnounces.add(ann);
      }
    }

    return newAnnounces;
  }

  Future<void> writeAnnouncementSubcategoryParameters({
    required String id,
    required String announcement,
    required AnnouncementCreatingData creatingData,
    required List<Parameter> parameters,
    required double lat,
    required double lng,
    required MarksFilter? marksFilter,
    required CarFilter? carFilter,
  }) async {
    final data = <String, dynamic>{
      'announcements': announcement,
      'latitude': lat,
      'longitude': lng,
      'area_id': creatingData.areaId,
      'city_id': creatingData.cityId,
      'price': creatingData.price,
      'price_type': creatingData.priceType?.name ?? 'dzd',
      'title': creatingData.title,
      'active': true,
    };

    if (carFilter != null) {
      data.addAll({'mark': carFilter.markId});
      data.addAll({'model': carFilter.modelId});
    }

    if (marksFilter != null) {
      data.addAll({'mark': marksFilter.markId});
      if (marksFilter.modelId != null) {
        data.addAll({'model': marksFilter.modelId});
      }
    }

    for (var parameter in parameters) {
      if (parameter is SelectParameter) {
        data.addAll({parameter.key: parameter.currentValue.key});
      } else if (parameter is MultiSelectParameter) {
        final value = parameter.selectedVariants.map((e) => e.key).toList();
        data.addAll({parameter.key: value});
      } else {
        data.addAll({parameter.key: parameter.currentValue});
      }
    }

    await _databases.createDocument(
      databaseId: mainDatabase,
      collectionId: creatingData.subcategoryId!,
      documentId: id,
      data: data,
    );
  }

  Future<void> incTotalViewsById(String id) async {
    final res = await _databases.getDocument(
      databaseId: mainDatabase,
      collectionId: postCollection,
      documentId: id,
    );

    await _databases.updateDocument(
      databaseId: mainDatabase,
      collectionId: postCollection,
      documentId: id,
      data: {totalViews: res.data[totalViews] + 1},
    );
  }

  Future<void> incContactsViewsById(String id) async {
    final res = await _databases.getDocument(
      databaseId: mainDatabase,
      collectionId: postCollection,
      documentId: id,
    );

    await _databases.updateDocument(
      databaseId: mainDatabase,
      collectionId: postCollection,
      documentId: id,
      data: {contactsViews: res.data[contactsViews] + 1},
    );
  }

  Future<void> createAnnouncement(
    String uid,
    List<String> urls,
    AnnouncementCreatingData creatingData,
    List<Parameter> subcategoryParameters,
    CityDistrict district,
    LatLng? customPosition,
    MarksFilter? marksFilter,
    CarFilter? carFilter,
  ) async {
    final data = creatingData.toJson(uid, urls);

    double lat = district.latitude;
    double lng = district.longitude;

    if (customPosition != null) lat = customPosition.latitude;
    if (customPosition != null) lng = customPosition.longitude;

    data.addAll({
      'latitude': lat,
      'longitude': lng,
    });

    if (carFilter != null) {
      data.addAll({'mark': carFilter.markId});
      data.addAll({'model': carFilter.modelId});
    }

    if (marksFilter != null) {
      data.addAll({'mark': marksFilter.markId});
      if (marksFilter.modelId != null) {
        data.addAll({'model': marksFilter.modelId});
      }
    }

    final doc = await _databases.createDocument(
      databaseId: mainDatabase,
      collectionId: postCollection,
      documentId: ID.unique(),
      data: data,
    );

    await writeAnnouncementSubcategoryParameters(
      id: doc.$id,
      announcement: doc.$id,
      creatingData: creatingData,
      parameters: subcategoryParameters,
      lat: lat,
      lng: lng,
      marksFilter: marksFilter,
      carFilter: carFilter,
    );
  }

  Future getUserAnnouncements({required String userId}) async {
    final res = await _databases.listDocuments(
        databaseId: mainDatabase,
        collectionId: postCollection,
        queries: [
          Query.equal("creator_id", userId),
          Query.orderDesc(DefaultDocumentParameters.createdAt)
        ]);

    return announcementsFromDocuments(res.documents, _storage);
  }

  Future changeAnnouncementActivity(String announcementsId) async {
    final res = await _databases.getDocument(
        databaseId: mainDatabase,
        collectionId: postCollection,
        documentId: announcementsId);

    final bool currentValue = res.data[activeAttribute];

    await _databases.updateDocument(
        databaseId: mainDatabase,
        collectionId: postCollection,
        documentId: announcementsId,
        data: {activeAttribute: !currentValue});
  }

  Future<Uint8List> getAnnouncementImage(String url) async {
    final id = getIdFromUrl(url);

    final futureBytes =
        _storage.getFileView(bucketId: announcementsBucketId, fileId: id);

    return futureBytes;
  }

  Future<Announcement> getAnnouncementById(String announcementId) async {
    final res = await _databases.getDocument(
      databaseId: mainDatabase,
      collectionId: postCollection,
      documentId: announcementId,
    );

    final futureBytes = getAnnouncementImage(res.data['images'][0]);

    return Announcement.fromJson(json: res.data, futureBytes: futureBytes);
  }

  Future<void> editAnnouncement({
    required AnnouncementEditData editData,
    required String? newSubcategoryid,
    required String? newMarkId,
    required String? newModelId,
  }) async {
    final subcollectionUpdateData = _subcollectionUpdateData(editData);

    final postCollectionUpdateData = await _postCollectionUpdateData(
      editData,
      newSubcategoryid,
      newMarkId,
      newModelId,
    );

    await _databases.updateDocument(
      databaseId: mainDatabase,
      collectionId: postCollection,
      documentId: editData.id,
      data: postCollectionUpdateData,
    );

    if (newSubcategoryid != null &&
        editData.subcollectionId != newSubcategoryid) {
      final subcollectionCreateData = _subcollectionCreateData(editData);

      // final existsDocument = await _databases.listDocuments(
      //   databaseId: mainDatabase,
      //   collectionId: newSubcategoryid,
      //   queries: [Query.equal('\$id', editData.id)],
      // );

      // if (existsDocument.documents.isEmpty) {
      //   await _databases.createDocument(
      //     databaseId: mainDatabase,
      //     collectionId: newSubcategoryid,
      //     documentId: editData.id,
      //     data: subcollectionCreateData,
      //   );
      // } else {
      //   await _databases.updateDocument(
      //     databaseId: mainDatabase,
      //     collectionId: newSubcategoryid,
      //     documentId: editData.id,
      //     data: subcollectionCreateData,
      //   );
      // }

      await _databases.createDocument(
        databaseId: mainDatabase,
        collectionId: newSubcategoryid,
        documentId: editData.id,
        data: subcollectionCreateData,
      );

      //* deleteDocument
      await _databases.updateDocument(
        databaseId: mainDatabase,
        collectionId: editData.subcollectionId,
        documentId: editData.id,
        data: {'announcements': null},
      );
      await _databases.deleteDocument(
        databaseId: mainDatabase,
        collectionId: editData.subcollectionId,
        documentId: editData.id,
      );
    } else {
      await _databases.updateDocument(
        databaseId: mainDatabase,
        collectionId: editData.subcollectionId,
        documentId: editData.id,
        data: subcollectionUpdateData,
      );
    }
  }

  Future<void> deleteAnnouncement(String id) async {
    final res = await _databases.getDocument(
      databaseId: mainDatabase,
      collectionId: postCollection,
      documentId: id,
    );

    await _databases.deleteDocument(
      databaseId: mainDatabase,
      collectionId: postCollection,
      documentId: id,
    );

    await _databases.deleteDocument(
      databaseId: mainDatabase,
      collectionId: res.data['subcategoryId'],
      documentId: id,
    );
  }

  _subcollectionUpdateData(AnnouncementEditData editData) {
    final subcollectionUpdateData = <String, dynamic>{
      'price': editData.price,
      'price_type': editData.priceType.name,
      'title': editData.title,
      'city_id': editData.cityId,
      'area_id': editData.areaId,
    };

    for (var parameter in editData.parameters) {
      if (parameter is SelectParameter) {
        subcollectionUpdateData
            .addAll({parameter.key: parameter.currentValue.key});
      } else if (parameter is MultiSelectParameter) {
        final value = parameter.selectedVariants.map((e) => e.key).toList();
        subcollectionUpdateData.addAll({parameter.key: value});
      } else {
        subcollectionUpdateData.addAll({parameter.key: parameter.currentValue});
      }
    }

    return subcollectionUpdateData;
  }

  _postCollectionUpdateData(AnnouncementEditData editData,
      String? newSubcategoryid, String? newMarkId, String? newModelId) async {
    List<Parameter> parametersWithMarkAndModel = [];

    // final mark = await _databases.getDocument(
    //   databaseId: mainDatabase,
    //   collectionId: marksCollection,
    //   documentId: editData.markId,
    // );
    // if (mark.data['name'] != null) {
    //   parametersWithMarkAndModel.add(
    //     TextParameter(
    //       key: 'car_mark',
    //       arName: 'العلامة التجارية',
    //       frName: 'Marque',
    //       value: mark.data['name'],
    //     ),
    //   );
    // }

    // final model = await _databases.getDocument(
    //   databaseId: mainDatabase,
    //   collectionId: modelsCollection,
    //   documentId: editData.modelId,
    // );
    // if (model.data['name'] != null) {
    //   parametersWithMarkAndModel.add(
    //     TextParameter(
    //       key: 'car_model',
    //       arName: 'نموذج',
    //       frName: 'Modèle',
    //       value: model.data['name'],
    //     ),
    //   );
    // }

    parametersWithMarkAndModel.addAll(editData.parameters);
    final postCollectionUpdateData = editData.toJson(
      newSubcategoryid ?? editData.subcollectionId,
      newMarkId,
      newModelId,
      parametersWithMarkAndModel,
    );
    return postCollectionUpdateData;
  }

  _subcollectionCreateData(AnnouncementEditData editData) {
    final subcollectionCreateData = <String, dynamic>{
      'announcements': editData.id,
      'latitude': editData.latitude,
      'longitude': editData.longitude,
      'price': editData.price,
      'price_type': editData.priceType.name,
      'title': editData.title,
      'city_id': editData.cityId,
      'area_id': editData.areaId,
      'active': true,
    };

    if (editData.markId != '') {
      subcollectionCreateData.addAll({'mark': editData.markId});
    }

    if (editData.modelId != '') {
      subcollectionCreateData.addAll({'model': editData.modelId});
    }

    for (var parameter in editData.parameters) {
      if (parameter is SelectParameter) {
        subcollectionCreateData
            .addAll({parameter.key: parameter.currentValue.key});
      } else if (parameter is MultiSelectParameter) {
        final value = parameter.selectedVariants.map((e) => e.key).toList();
        subcollectionCreateData.addAll({parameter.key: value});
      } else {
        subcollectionCreateData.addAll({parameter.key: parameter.currentValue});
      }
    }

    return subcollectionCreateData;
  }
}
