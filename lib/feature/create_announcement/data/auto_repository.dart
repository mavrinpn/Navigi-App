import 'package:smart/feature/create_announcement/data/models/auto_marks.dart';
import 'package:smart/feature/create_announcement/data/models/auto_model.dart';
import 'package:smart/services/database/database_service.dart';

class AutoMarksRepository {
  final DatabaseService databaseService;

  AutoMarksRepository(this.databaseService);

  Future<List<Mark>> getMarks() =>
      databaseService.categories.getAutoMarks();

  Future<List<AutoModel>> getModels(String markId) =>
      databaseService.categories.getAutoModels(markId);
}
