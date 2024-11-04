import 'package:appwrite/appwrite.dart';
import 'package:smart/services/database/database_service.dart';

class SynonymsManager {
  final DatabaseService databaseService;
  final Client client;
  final Account account;

  SynonymsManager({
    required this.databaseService,
    required this.client,
  }) : account = Account(client);

  Future<List<String>> loadSynonyms({
    required String word,
  }) async =>
      databaseService.synonyms.loadSynonyms(word: word);
}
