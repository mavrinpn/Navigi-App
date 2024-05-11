import 'package:appwrite/appwrite.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/models/key_word.dart';
import 'package:smart/services/database/database_service.dart';

const String _historyKey = 'history';

class SearchManager {
  final DatabaseService dbService;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  SearchManager({required Client client}) : dbService = DatabaseService(client: client);

  var popularQueries = <String>[];

  Announcement? lastAnnouncement;

  bool isSearch = true;

  BehaviorSubject<String> searchTextStream = BehaviorSubject<String>.seeded('');

  // Future<List<SubcategoryItem>> searchItemsByName(String query) async =>
  //     await dbService.categories.searchItemsByQuery(query);

  Future<List<KeyWord>> getKeyWords({
    required String name,
    required String? subcategoryId,
  }) async =>
      await dbService.categories.getKeyWords(
        name: name,
        subcategoryId: subcategoryId,
      );

  Future<void> loadPopularQueries() async {
    if (popularQueries.isEmpty) {
      popularQueries = await dbService.categories.getPopularQueries();
    }
  }

  void setSearch(bool f) {
    isSearch = f;
  }

  Future<List<String>> getHistory() async {
    final prefs = await _prefs;

    final List<String> history = prefs.getStringList(_historyKey) ?? [];
    return history.reversed.toList();
  }

  Future<List<String>> saveInHistory(String query) async {
    final prefs = await _prefs;

    List<String> history = prefs.getStringList(_historyKey) ?? [];

    if (query.isEmpty) return history;

    if (history.length >= 10) {
      history.removeAt(0);
    }

    history.add(query);
    await prefs.setStringList(_historyKey, history);

    return history;
  }

  Future<void> deleteQueryByName(String name) async {
    final prefs = await _prefs;

    List<String> history = prefs.getStringList(_historyKey) ?? [];

    history.remove(name);

    await prefs.setStringList(_historyKey, history);
  }

  Future<void> clearQuery() async {
    final prefs = await _prefs;

    List<String> history = prefs.getStringList(_historyKey) ?? [];

    history.clear();

    await prefs.setStringList(_historyKey, history);
  }
}
