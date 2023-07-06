import '../../../models/models.dart';
import '../../../services/database_manager.dart';

class CategoriesManager {
  final DatabaseManger databaseManger;

  CategoriesManager({required this.databaseManger});

  List<Category> categories = [];
  List<Subcategory> subcategories = [];

  Future loadCategories() async =>
      categories = await databaseManger.loadCategories();

  Future loadSubCategories(String categoryID) async =>
      subcategories = await databaseManger.loadSubCategories(categoryID);
}
