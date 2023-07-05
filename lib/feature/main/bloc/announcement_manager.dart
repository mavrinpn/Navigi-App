import 'package:appwrite/appwrite.dart';

import '../../../models/announcement.dart';
import '../../../utils/constants.dart';

class AnnouncementManager {
  final Databases _databases;

  AnnouncementManager({required Client client})
      : _databases = Databases(client);

  String? _lastId;
  static const int _amount = 3;

  List<Announcement> announcements = [];
  AnnouncementData? _lastAnnouncement;

  Future<void> getAllAnnouncements() async {
    try {
      final res = await _databases.listDocuments(
          databaseId: postDatabase,
          collectionId: postCollection,
          queries: _lastId == null
              ? [Query.limit(_amount)]
              : [Query.limit(_amount), Query.cursorAfter(_lastId!)]);

      List<Announcement> newAnnounces = [];
      for (var doc in res.documents) {
        newAnnounces.add(Announcement.fromJson(json: doc.data));
      }

      announcements.addAll(newAnnounces);
      _lastId = newAnnounces.last.announcementId;
    } catch (e) {
      if (e.toString() != 'Bad state: No element') {
        rethrow;
      }
    }
  }

  Future<AnnouncementData> getAnnouncementById(String id) async {
    if (id == _lastAnnouncement?.announcementId) {
      return _lastAnnouncement!;
    } else {
      final res = await _databases.getDocument(
          databaseId: postDatabase,
          collectionId: postCollection,
          documentId: id);
      final announcement = AnnouncementData.fromJson(json: res.data);
      _lastAnnouncement = announcement;
      return announcement;
    }
  }
}
