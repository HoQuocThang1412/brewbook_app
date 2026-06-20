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

  static const _items = [
    _NavItemData(Icons.dashboard_outlined, Icons.dashboard_rounded, 'Tổng quan'),
    _NavItemData(Icons.local_cafe_outlined, Icons.local_cafe_rounded, 'Công thức'),
    _NavItemData(Icons.assignment_outlined, Icons.assignment_turned_in_rounded, 'Báo cáo'),
    _NavItemData(Icons.assignment_ind_outlined, Icons.assignment_ind_rounded, 'Quy trình'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
            boxShadow: const [
              BoxShadow(color: AppColors.shadow, blurRadius: 18, offset: Offset(0, 8)),
            ],
          ),
          child: Row(
            children: List.generate(_items.length, (i) {
              return Expanded(
                child: _NavItem(
                  data: _items[i],
                  selected: _index == i,
                  onTap: () => setState(() => _index = i),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final _NavItemData data;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({required this.data, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: AnimatedContainer(
        height: 58,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: selected ? AppColors.goldSoft : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selected ? data.activeIcon : data.icon,
              color: selected ? AppColors.coffeeBrown : AppColors.textSecondary,
              size: 23,
            ),
            const SizedBox(height: 4),
            Text(
              data.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: selected ? AppColors.coffeeBrown : AppColors.textSecondary,
                fontSize: 10.5,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItemData {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItemData(this.icon, this.activeIcon, this.label);
}
