import 'package:smart/feature/create_announcement/data/models/mark.dart';
import 'package:smart/feature/create_announcement/data/models/mark_model.dart';
import 'package:smart/services/database/database_service.dart';

class MarksRepository {
  final DatabaseService databaseService;

  MarksRepository(this.databaseService);

  Future<List<Mark>> getMarks(String subcategory) =>
      databaseService.categories.getSubcategoryMarks(subcategory);

  Future<List<MarkModel>> getModels({required String markId, required String subcategory}) =>
      databaseService.categories.getSubcategoryMarksModels(subcategory: subcategory, mark: markId);
}
