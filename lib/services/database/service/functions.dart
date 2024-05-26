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
  required String imageUrl,
}) {
  late final Future<Uint8List> futureBytes;
  final id = getIdFromUrl(imageUrl);
  if (id != null) {
    futureBytes = storage.getFileView(
      bucketId: announcementsBucketId,
      fileId: id,
    );
  } else if (imageUrl.isNotEmpty) {
    futureBytes = http.get(Uri.parse(imageUrl)).then((value) => value.bodyBytes);
  } else {
    futureBytes = Future.value(Uint8List.fromList([]));
  }
  return futureBytes;
}

List<Announcement> announcementsFromDocuments(List<Document> documents, Storage storage) {
  List<Announcement> newAnnounces = [];
  for (var doc in documents) {
    final imageUrl = doc.data['images'][0];
    final futureBytes = futureBytesForImageURL(
      storage: storage,
      imageUrl: imageUrl,
    );

    doc.data.forEach((key, value) {
      // print('$key: $value');
    });

    newAnnounces.add(Announcement.fromJson(json: doc.data, futureBytes: futureBytes));
  }

  return newAnnounces;
}
