import 'package:appwrite/appwrite.dart';
import 'package:smart/models/tip_word.dart';
import 'package:smart/services/database/database_service.dart';

class TipWordsManager {
  final DatabaseService databaseService;
  final Client client;
  final Account account;

  TipWordsManager({
    required this.databaseService,
    required this.client,
  }) : account = Account(client);

  Future<List<TipWord>> searchBy({
    required String subcategoryId,
    required String? query,
    required String? markId,
    required String? modelId,
    required String? previousWordId,
    required String? previousWordGroupId,
  }) async =>
      databaseService.tipWords.searchBy(
        subcategoryId: subcategoryId,
        query: query,
        markId: markId,
        modelId: modelId,
        previousWordId: previousWordId,
        previousWordGroupId: previousWordGroupId,
      );
}
