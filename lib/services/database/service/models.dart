part of '../database_service.dart';

class ModelsService {
  final Databases _databases;

  ModelsService(Databases databases) : _databases = databases;

  Future<String?> getModelNameById({
    required String modelId,
  }) async {
    final res = await _databases.getDocument(
      documentId: modelId,
      databaseId: mainDatabase,
      collectionId: modelsCollection,
    );

    return res.data['name'];
  }

  Future<String?> getMarkNameById({
    required String markId,
  }) async {
    final res = await _databases.getDocument(
      documentId: markId,
      databaseId: mainDatabase,
      collectionId: marksCollection,
    );

    return res.data['name'];
  }

  Future<MarkModel?> getMarkModelById({
    required String modelId,
  }) async {
    final res = await _databases.getDocument(
      documentId: modelId,
      databaseId: mainDatabase,
      collectionId: modelsCollection,
    );

    if (res.data['\$id'] != null) {
      return MarkModel(
        res.data['\$id'],
        res.data['name'] ?? '',
        res.data['parameters'],
      );
    }
    return null;
  }

  Future<CarModel> getCarModelById({
    required String modelId,
  }) async {
    final res = await _databases.getDocument(
      documentId: modelId,
      databaseId: mainDatabase,
      collectionId: modelsCollection,
    );

    String complectations = '';
    String engines = '';
    if (res.data['parameters'] != null) {
      final string = res.data['parameters'] as String;
      for (var param in jsonDecode(string.replaceAll("'", '"'))) {
        final paramMap = param as Map<String, dynamic>;
        final id = paramMap['id'] as String;
        if (id == 'complectation') {
          final type = paramMap['type'] as String;
          if (type == 'option') {
            final options = paramMap['options'] as List;
            complectations = jsonEncode(options);
          }
        } else if (id == 'engine') {
          final type = paramMap['type'] as String;
          if (type == 'option') {
            final options = paramMap['options'] as List;
            engines = jsonEncode(options);
          }
        }
      }
    }

    return CarModel(
      res.data['\$id'],
      res.data['name'] ?? '',
      complectations,
      engines,
    );
  }
}
