part of '../database_service.dart';

class MediumPriceService {
  final Databases _databases;

  MediumPriceService(Databases databases) : _databases = databases;

  Future<List<MediumPrice>> getWith({
    required String brand,
    required String model,
    required int? year,
  }) async {
    List<String> queries = [];
    queries.add(Query.equal('brand', brand));
    queries.add(Query.equal('model', model));
    if (year != null) {
      queries.add(Query.equal('year', year));
    }
    queries.add(Query.limit(1000));

    final res = await _databases.listDocuments(
      databaseId: mainDatabase,
      collectionId: mediumPriceCollection,
      queries: queries,
    );

    if (res.documents.isEmpty) {
      return _getWith(brand: brand, model: model);
    }

    return _parseDocuments(res);
  }

  Future<List<MediumPrice>> _getWith({
    required String brand,
    required String model,
  }) async {
    List<String> queries = [];
    queries.add(Query.equal('brand', brand));
    queries.add(Query.equal('model', model));
    queries.add(Query.limit(1000));

    final res = await _databases.listDocuments(
      databaseId: mainDatabase,
      collectionId: mediumPriceCollection,
      queries: queries,
    );

    return _parseDocuments(res);
  }

  List<MediumPrice> _parseDocuments(DocumentList res) {
    List<MediumPrice> result = [];
    for (var doc in res.documents) {
      result.add(MediumPrice.fromJson(doc.data));
    }

    return result;
  }
}
