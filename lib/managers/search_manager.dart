import 'package:appwrite/appwrite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart/models/announcement.dart';

import '../models/item/item.dart';
import '../services/database_service.dart';

const String _historyKey = 'history';

class SearchManager {
  final DatabaseManger dbManager;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  SearchManager({required Client client})
      : dbManager = DatabaseManger(client: client);

  var popularQueries = <String>[];

  String? lastId;
  Announcement? lastAnnouncement;
  String searchText = '';

  Future<List<SubCategoryItem>> searchItemsByName(String query) async =>
      await dbManager.searchItemByQuery(query);

  Future<void> loadPopularQueries() async {
    if (popularQueries.isEmpty) {
      popularQueries = await dbManager.popularQueries();
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

  void setSearchText(String str) => searchText = str;
}
