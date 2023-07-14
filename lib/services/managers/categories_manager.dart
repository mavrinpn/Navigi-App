import '../../models/models.dart';
import '../database_manager.dart';

class CategoriesManager {
  final DatabaseManger databaseManger;

  CategoriesManager({required this.databaseManger});

  List<Category> categories = [];
  List<Subcategory> subcategories = [];

  Future loadCategories() async =>
      categories = await databaseManger.getAllCategories();

  Future loadSubcategory(String categoryID) async => subcategories =
      await databaseManger.getAllSubCategoriesByCategoryId(categoryID);
}
