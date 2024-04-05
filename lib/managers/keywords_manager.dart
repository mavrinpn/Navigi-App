import 'package:appwrite/appwrite.dart';
import 'package:smart/models/key_word.dart';
import 'package:smart/services/database/database_service.dart';

class KeyWordsManager {
  final DatabaseService databaseService;
  final Client client;
  final Account account;

  KeyWordsManager({
    required this.databaseService,
    required this.client,
  }) : account = Account(client);

  Future<List<KeyWord>> searchByFr({
    required String subcategoryId,
    required String query,
  }) async =>
      databaseService.keyWords.searchByFr(
        subcategoryId: subcategoryId,
        query: query,
      );

  Future<List<KeyWord>> searchByAr({
    required String subcategoryId,
    required String query,
  }) async =>
      databaseService.keyWords.searchByAr(
        subcategoryId: subcategoryId,
        query: query,
      );
}
