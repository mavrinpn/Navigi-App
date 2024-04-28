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
    required String? lastWord,
    required String? wholeString,
    required String? markId,
    required String? modelId,
    required String? previousWordId,
    required String? previousWordGroupId,
  }) async {
    final List<TipWord> result = [];

    final listByLastWord = await databaseService.tipWords.searchByLastWord(
      subcategoryId: subcategoryId,
      query: lastWord,
      markId: markId,
      modelId: modelId,
      previousWordId: previousWordId,
      previousWordGroupId: previousWordGroupId,
    );
    result.addAll(listByLastWord);

    if (lastWord != null) {
      final listByWholeString = await databaseService.tipWords.searchByWholeString(
        subcategoryId: subcategoryId,
        query: lastWord,
        markId: markId,
        modelId: modelId,
      );
      result.addAll(listByWholeString);
    }

    return result;
  }
}
