import 'package:appwrite/appwrite.dart';

import '../../../models/announcement.dart';
import '../../../services/database_manager.dart';

class AnnouncementManager {
  final DatabaseManger dbManager;

  AnnouncementManager({required Client client})
      : dbManager = DatabaseManger(client: client);

  String? _lastId;
  static const int _amount = 3;

  List<String> viewsAnnouncements = [];
  List<Announcement> announcements = [];
  Announcement? lastAnnouncement;

  Future<void> addLimitAnnouncements() async {
    try {
      announcements.addAll(await dbManager.getLimitAnnouncements(_lastId, _amount));
      _lastId = announcements.last.announcementId;
    } catch (e) {
      if (e.toString() != 'Bad state: No element') {
        rethrow;
      }
    }
  }

  Future<Announcement> getAnnouncementById(String id) async {
    if (id == lastAnnouncement?.announcementId) {
      return lastAnnouncement!;
    } else {
      final announcement = await dbManager.getAnnouncementById(id);
      incTotalViews(announcement.announcementId, announcement.totalViews);
      lastAnnouncement = announcement;
      return announcement;
    }
  }

  void incTotalViews(String id, int views) async {
    if (!viewsAnnouncements.contains(id)) {
      dbManager.incTotalViewsById(id, views);
    }
  }
}
