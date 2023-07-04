import 'package:appwrite/appwrite.dart';

import '../../../models/announcement.dart';
import '../../../utils/constants.dart';

class AnnouncementManager {
  final Databases _databases;

  AnnouncementManager({required Client client})
      : _databases = Databases(client);

  String? _lastId;
  static const int _amount = 25;

  List<Announcement> announcements = [];

  Future<void> getAnnouncements() async {
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
  }
}
