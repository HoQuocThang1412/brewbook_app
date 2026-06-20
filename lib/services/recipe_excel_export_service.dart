import '../models/recipe.dart';
import 'hive_service.dart';
import 'recipe_excel_builder.dart';
import 'recipe_excel_storage.dart';

Future<int> exportRecipesToExcel() async {
  final recipes = HiveService.getAllRecipes()
      .where((recipe) => recipe.status == RecipeStatus.dangBan)
      .toList();

  final bytes = buildRecipeExcelWorkbook(recipes);
  await saveRecipeExcelBytes(bytes);
  return recipes.length;
}
