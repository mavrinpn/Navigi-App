part of '../database_service.dart';

class SynonymsService {
  final Databases _databases;

  SynonymsService(Databases databases) : _databases = databases;

  static const String synonymsCollectionId = '672646c0003d842b18b9';

  Future<List<String>> loadSynonyms({required String? word}) async {
    List<String> synonyms = [];
    if (word != null) {
      final synonymsRes = await _databases.listDocuments(
        databaseId: mainDatabase,
        collectionId: synonymsCollectionId,
        queries: [Query.contains('words', word.toLowerCase())],
      );

      for (var doc in synonymsRes.documents) {
        if (doc.data['words'] != null) {
          synonyms.addAll(List<String>.from(doc.data['words']));
        }
      }
    }
    return synonyms;
  }
}
