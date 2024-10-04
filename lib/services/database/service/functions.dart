part of '../database_service.dart';

String? getIdFromUrl(String url) {
  if (url.contains('v1/storage/buckets/')) {
    final split = url.split('/');
    return split[split.length - 2];
  }
  return null;
}

Future<Uint8List> futureBytesForImageURL({
  required Storage storage,
  required String? imageUrl,
}) {
  Future<Uint8List> futureBytes = storage.getFileView(
    bucketId: staffBucketId,
    fileId: 'no_photo',
  );
  if (imageUrl != null) {
    final id = getIdFromUrl(imageUrl);
    if (id != null) {
      try {
        futureBytes = storage.getFileView(
          bucketId: announcementsBucketId,
          fileId: id,
        );
      } catch (err) {
        return futureBytes;
      }
    } else if (imageUrl.isNotEmpty) {
      futureBytes = http.get(Uri.parse(imageUrl)).then((value) => value.bodyBytes);
    }
  }

  return futureBytes;
}

List<Announcement> announcementsFromDocuments(List<Document> documents, Storage storage) {
  List<Announcement> newAnnounces = [];
  for (var doc in documents) {
    // final imageUrl = doc.data['images'][0] ?? '';
    // final futureBytes = futureBytesForImageURL(
    //   storage: storage,
    //   imageUrl: imageUrl,
    // );
    newAnnounces.add(Announcement.fromJson(
      json: doc.data,
      // futureBytes: futureBytes,
      subcollTableId: '',
    ));
  }

  return newAnnounces;
}
