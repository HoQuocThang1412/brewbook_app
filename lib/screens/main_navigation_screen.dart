import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'dashboard_screen.dart';
import 'recipe_list_screen.dart';
import 'report_checklist_screen.dart';
import 'work_process_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _index = 0;

  final _pages = const [
    DashboardScreen(),
    RecipeListScreen(),
    ReportChecklistScreen(),
    WorkProcessScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _index,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) {
          setState(() {
            _index = i;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard_rounded),
            label: 'Tổng quan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book_rounded),
            label: 'Công thức',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment_turned_in_rounded),
            label: 'Báo cáo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_ind_outlined),
            activeIcon: Icon(Icons.assignment_ind_rounded),
            label: 'Quy trình',
          ),
        ],
      ),
    );
  }
}