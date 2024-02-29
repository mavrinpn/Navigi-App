import 'package:smart/feature/create_announcement/data/models/auto_marks.dart';
import 'package:smart/feature/create_announcement/data/models/auto_model.dart';
import 'package:smart/services/database/database_service.dart';

class CarMarksRepository {
  final DatabaseService databaseService;

  CarMarksRepository(this.databaseService);

  Future<List<Mark>> getMarks(String subcategory) =>
      databaseService.categories.getCarMarks(subcategory);

  Future<List<CarModel>> getModels({
    required String subcategory,
    required String markId,
  }) =>
      databaseService.categories.getCarModels(
        subcategory: subcategory,
        mark: markId,
      );
}
