part of '../database_service.dart';

class AnnouncementsService {
  final Databases _databases;
  final Storage _storage;

  static const String activeAttribute = 'active';

  AnnouncementsService(Databases databases, Storage storage)
      : _databases = databases,
        _storage = storage;

  Future<List<Announcement>> getAnnouncements(String? lastId) async {
    List<String> queries = [
      Query.orderDesc(DefaultDocumentParameters.createdAt),
      Query.equal(activeAttribute, true),
      Query.limit(24)
    ];
    if ((lastId ?? '').isEmpty) lastId = null;

    if (lastId != null) queries.add(Query.cursorAfter(lastId));

    final res = await _databases.listDocuments(
        databaseId: mainDatabase,
        collectionId: postCollection,
        queries: queries);

    List<Announcement> newAnnounces =
        announcementsFromDocuments(res.documents, _storage);

    return newAnnounces;
  }

  Future<List<Announcement>> searchLimitAnnouncements(
      String? lastId, String? searchText, String? sortBy,
      {double? minPrice, double? maxPrice}) async {
    List<String> queries = [];

    queries.add(Query.equal(activeAttribute, true));
    if ((lastId ?? "").isEmpty) lastId = null;

    if (lastId != null) queries.add(Query.cursorAfter(lastId));
    if (searchText != null && searchText.isNotEmpty) {
      queries.add(Query.search('name', searchText));
    }
    if (sortBy != null) queries.add(SortTypes.toQuery(sortBy)!);
    if (minPrice != null) {
      queries.add(Query.greaterThanEqual('price', minPrice));
    }
    if (maxPrice != null) queries.add(Query.lessThanEqual('price', maxPrice));

    final res = await _databases.listDocuments(
        databaseId: mainDatabase,
        collectionId: postCollection,
        queries: queries);

    List<Announcement> newAnnounces =
        announcementsFromDocuments(res.documents, _storage);

    return newAnnounces;
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

  Future<void> createAnnouncement(String uid, List<String> urls,
      AnnouncementCreatingData creatingData) async {
    await _databases.createDocument(
        databaseId: mainDatabase,
        collectionId: postCollection,
        documentId: ID.unique(),
        data: creatingData.toJson(uid, urls));
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
}
