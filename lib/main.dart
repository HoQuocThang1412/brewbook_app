import 'package:flutter/material.dart';
import 'services/hive_service.dart';
import 'theme/app_theme.dart';
import 'screens/main_navigation_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  runApp(const BrewBookApp());
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
