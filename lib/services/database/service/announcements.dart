part of '../database_service.dart';

class AnnouncementsService {
  final Databases _databases;
  final Storage _storage;

  static const String activeAttribute = 'active';

  AnnouncementsService(Databases databases, Storage storage)
      : _databases = databases,
        _storage = storage;

  Future<List<Announcement>> getAnnouncements(String? lastId) async {
    List<String> queries = ParametersFilterBuilder.getQueriesForGet(lastId);

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

        newAnnounces.add(Announcement.fromJson(
          json: doc.data['announcements'],
          futureBytes: futureBytes,
        ));
      }
    }

    return newAnnounces;
  }

  Future<void> writeAnnouncementSubcategoryParameters(
      String announcement,
      AnnouncementCreatingData creatingData,
      List<Parameter> parameters,
      double lat,
      double lng,
      MarksFilter? marksFilter) async {
    final data = <String, dynamic>{
      'announcements': announcement,
      'latitude': lat,
      'longitude': lng,
      'area_id': creatingData.areaId,
      'city_id': creatingData.cityId,
      'price': creatingData.price,
      'title': creatingData.title,
      'active': true,
    };

    if (marksFilter != null) {
      data.addAll({'mark': marksFilter.markId});
      if (marksFilter.modelId != null) {
        data.addAll({'model': marksFilter.modelId});
      }
    }

    for (var i in parameters) {
      data.addAll(
          {i.key: i is SelectParameter ? i.currentValue.key : i.currentValue});
    }

    await _databases.createDocument(
      databaseId: mainDatabase,
      collectionId: creatingData.subcategoryId!,
      documentId: ID.unique(),
      data: data,
    );
  }

  Future<void> incTotalViewsById(String id) async {
    final res = await _databases.getDocument(
        databaseId: mainDatabase, collectionId: postCollection, documentId: id);

    await _databases.updateDocument(
        databaseId: mainDatabase,
        collectionId: postCollection,
        documentId: id,
        data: {totalViews: res.data[totalViews] + 1});
  }

  Future<void> createAnnouncement(
    String uid,
    List<String> urls,
    AnnouncementCreatingData creatingData,
    List<Parameter> subcategoryParameters,
    CityDistrict district,
    LatLng? customPosition,
    MarksFilter? marksFilter,
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

    final doc = await _databases.createDocument(
      databaseId: mainDatabase,
      collectionId: postCollection,
      documentId: ID.unique(),
      data: data,
    );

    await writeAnnouncementSubcategoryParameters(
      doc.$id,
      creatingData,
      subcategoryParameters,
      lat,
      lng,
      marksFilter,
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
        documentId: announcementId);

    final futureBytes = getAnnouncementImage(res.data['images'][0]);

    return Announcement.fromJson(json: res.data, futureBytes: futureBytes);
  }

  Future<void> editAnnouncement(AnnouncementEditData editData) async {
    await _databases.updateDocument(
        databaseId: mainDatabase,
        collectionId: postCollection,
        documentId: editData.id,
        data: editData.toJson());
  }

  Future<void> deleteAnnouncement(String id) async {
    await _databases.deleteDocument(
        databaseId: mainDatabase, collectionId: postCollection, documentId: id);
  }
}
