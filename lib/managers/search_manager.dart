import 'package:appwrite/appwrite.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/item/item.dart';
import '../services/database_manager.dart';

class SearchManager {
  final DatabaseManger dbManager;

  SearchManager({required Client client})
      : dbManager = DatabaseManger(client: client);

  var popularQueries = <String>[];

  Future<List<SubCategoryItem>> searchItemsByName(String query) async =>
      await dbManager.searchItemByQuery(query);

  Future<void> loadPopularQueries() async {
    if(popularQueries.isEmpty){
      popularQueries = await dbManager.popularQueries();
    }
  }
}
