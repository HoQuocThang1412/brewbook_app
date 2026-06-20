import 'package:hive/hive.dart';

import '../models/recipe.dart';
import 'imported_recipes.dart';
import 'recovered_test_recipe_seed.dart';

Future<void> seedSampleData(Box<Recipe> box) async {
  await seedImportedRecipes(box);
  await seedRecoveredTestRecipes(box);
}
