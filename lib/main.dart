import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'services/hive_service.dart';
import 'services/imported_recipes.dart';
import 'theme/app_theme.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/welcome_screen.dart';

bool _showRecipeUpdateMessage = false;
int _updatedRecipeCount = 0;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  await _syncExcelRecipesIfNeeded();
  runApp(const BrewBookApp());
}

Future<void> _syncExcelRecipesIfNeeded() async {
  final settingsBox = await Hive.openBox('settings_box');
  final currentVersion = settingsBox.get('recipe_seed_version') as String?;

  if (currentVersion == excelRecipesSeedVersion) return;

  _updatedRecipeCount = await replaceImportedRecipes(HiveService.box);
  _showRecipeUpdateMessage = true;
  await settingsBox.put('recipe_seed_version', excelRecipesSeedVersion);
}

class BrewBookApp extends StatelessWidget {
  const BrewBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrewBook',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: WelcomeScreen(
        nextScreen: _StartupMessageWrapper(
          showRecipeUpdateMessage: _showRecipeUpdateMessage,
          updatedRecipeCount: _updatedRecipeCount,
          child: const MainNavigationScreen(),
        ),
      ),
    );
  }
}

class _StartupMessageWrapper extends StatefulWidget {
  final bool showRecipeUpdateMessage;
  final int updatedRecipeCount;
  final Widget child;

  const _StartupMessageWrapper({
    required this.showRecipeUpdateMessage,
    required this.updatedRecipeCount,
    required this.child,
  });

  @override
  State<_StartupMessageWrapper> createState() => _StartupMessageWrapperState();
}

class _StartupMessageWrapperState extends State<_StartupMessageWrapper> {
  @override
  void initState() {
    super.initState();
    if (widget.showRecipeUpdateMessage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã cập nhật công thức mới (${widget.updatedRecipeCount} mục)'),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
