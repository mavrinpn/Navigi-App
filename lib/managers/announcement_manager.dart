import 'package:appwrite/appwrite.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/announcement.dart';
import '../services/database_manager.dart';

const String _historyKey = 'history';

class AnnouncementManager {
  final DatabaseManger dbManager;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  AnnouncementManager({required Client client})
      : dbManager = DatabaseManger(client: client);

  String? _lastId;
  bool _canGetMore = true;

  List<String> viewsAnnouncements = [];
  List<Announcement> announcements = [];
  Announcement? lastAnnouncement;

  Future<List<Announcement>> searchAnnouncements(String query) async =>
      await dbManager.searchAnnouncementByQuery(query);

  Future<void> addLimitAnnouncements() async {
    if (_canGetMore) {
      try {
        announcements.addAll(await dbManager.getLimitAnnouncements(_lastId));
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

  Future<List<String>> getHistory() async {
    final prefs = await _prefs;

    final List<String> history = prefs.getStringList(_historyKey) ?? [];
    return history;
  }

  Future<List<String>> saveInHistory(String query) async {
    final prefs = await _prefs;

    List<String> history = prefs.getStringList(_historyKey) ?? [];

    if (history.length >= 10) {
      history.removeAt(0);
    }

    history.add(query);
    await prefs.setStringList(_historyKey, history);

    return history;
  }

  Future<Announcement?> getAnnouncementById(String id) async {
    for (var a in announcements) {
      if (a.announcementId == id) {
        lastAnnouncement = a;
        return a;
      }
    }
    return null;
  }

  void incTotalViews(String id) async {
    if (!viewsAnnouncements.contains(id)) {
      dbManager.incTotalViewsById(id);
      viewsAnnouncements.add(id);
    }
  }
}
