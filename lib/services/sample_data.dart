import 'package:hive/hive.dart';

import '../models/recipe.dart';
import 'imported_recipes.dart';

Future<void> seedSampleData(Box<Recipe> box) async {
  return seedImportedRecipes(box);
}
