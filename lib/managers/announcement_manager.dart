import 'package:appwrite/appwrite.dart';

import '../../models/announcement.dart';
import '../services/database_manager.dart';

class AnnouncementManager {
  final DatabaseManger dbManager;

  AnnouncementManager({required Client client})
      : dbManager = DatabaseManger(client: client);

  String? _lastId;
  bool _canGetMore = true;
  static const int _amount = 6;

  List<String> viewsAnnouncements = [];
  List<Announcement> announcements = [];
  Announcement? lastAnnouncement;

  Future<void> addLimitAnnouncements() async {
    if (_canGetMore) {
      try {
        announcements.addAll(await dbManager.getLimitAnnouncements(_lastId, _amount));
        _lastId = announcements.last.announcementId;
      } catch (e) {
        if (e.toString() != 'Bad state: No element') {
          rethrow;
        } else {
          _canGetMore = false;
        }
      }
    }
  }

  Future<Announcement?> getAnnouncementById(String id) async {
    for (var a in announcements) {
      if (a.announcementId == id) {
        lastAnnouncement = a;
        return a;
      }
    }
    return null;

    // if (id == lastAnnouncement?.announcementId) {
    //   return lastAnnouncement!;
    // } else {
    //   final announcement = await dbManager.getAnnouncementById(id);
    //   incTotalViews(announcement.announcementId);
    //
    //   return announcement;
    // }
  }

  void incTotalViews(String id) async {
    if (!viewsAnnouncements.contains(id)) {
      dbManager.incTotalViewsById(id);
      viewsAnnouncements.add(id);
    }
  }
}
