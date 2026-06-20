import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'services/hive_service.dart';
import 'services/imported_recipes.dart';
import 'theme/app_theme.dart';
import 'screens/main_navigation_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  await _seedExcelRecipesOnce();
  runApp(const BrewBookApp());
}

Future<void> _seedExcelRecipesOnce() async {
  final settingsBox = await Hive.openBox('settings_box');
  final alreadySeeded = settingsBox.get(excelRecipesSeedVersion) == true;

  if (alreadySeeded) return;

  await seedImportedRecipes(HiveService.box);
  await settingsBox.put(excelRecipesSeedVersion, true);
}

class BrewBookApp extends StatelessWidget {
  const BrewBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrewBook',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainNavigationScreen(),
    );
  }
}
