import 'package:smart/services/database/database_service.dart';

class MarkModelManager {
  final DatabaseService databaseService;

  MarkModelManager({required this.databaseService});

  Future<String?> getMarkNameById(String markId) async =>
      databaseService.models.getMarkNameById(markId: markId);

  Future<String?> getModelNameById(String modelId) async {
    return databaseService.models.getModelNameById(modelId: modelId);

    //TODO
    // databaseService.models.test();
  }
      
}
