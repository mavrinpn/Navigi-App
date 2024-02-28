part of '../database_service.dart';

getIdFromUrl(String url) {
  final split = url.split('/');
  return split[split.length - 2];
}

List<Announcement> announcementsFromDocuments(
    List<Document> documents, Storage storage) {
  List<Announcement> newAnnounces = [];
  for (var doc in documents) {
    final id = getIdFromUrl(doc.data['images'][0]);

    final futureBytes =
        storage.getFileView(bucketId: announcementsBucketId, fileId: id);

    doc.data.forEach((key, value) {
      // print('$key: $value');
    });

    newAnnounces
        .add(Announcement.fromJson(json: doc.data, futureBytes: futureBytes));
  }

  return newAnnounces;
}
