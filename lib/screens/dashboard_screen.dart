import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/recipe.dart';
import '../services/hive_service.dart';
import '../theme/app_colors.dart';
import '../widgets/stat_card.dart';
import 'recipe_list_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  void _openRecipeList(
    BuildContext context, {
    String? status,
    bool showCategorySummary = false,
    String? title,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RecipeListScreen(
          initialStatus: status,
          showCategorySummary: showCategorySummary,
          pageTitle: title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('☕ Ứng dụng quản lý công thức pha chế'),
      ),
      body: ValueListenableBuilder(
        valueListenable: HiveService.listenable(),
        builder: (context, Box<Recipe> box, _) {
          final total = HiveService.totalRecipes;
          final dangBan = HiveService.totalDangBan;
          final groups = HiveService.totalCategories;
          final ngungBan = total - dangBan;

          return RefreshIndicator(
            onRefresh: () async {},
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                const Text(
                  'Tổng quan quán',
                  style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Chào mừng quay lại! 👋',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.coffeeDark,
                  ),
                ),
                const SizedBox(height: 18),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.35,
                  children: [
                    _ClickableStatCard(
                      onTap: () => _openRecipeList(
                        context,
                        title: 'Tất cả công thức',
                      ),
                      child: StatCard(
                        title: 'Tổng số công thức',
                        value: '$total',
                        icon: Icons.menu_book_rounded,
                        accentColor: AppColors.coffeeBrown,
                      ),
                    ),
                    _ClickableStatCard(
                      onTap: () => _openRecipeList(
                        context,
                        status: RecipeStatus.dangBan,
                        title: 'Món đang bán',
                      ),
                      child: StatCard(
                        title: 'Món đang bán',
                        value: '$dangBan',
                        icon: Icons.local_cafe_rounded,
                        accentColor: AppColors.success,
                      ),
                    ),
                    _ClickableStatCard(
                      onTap: () => _openRecipeList(
                        context,
                        showCategorySummary: true,
                        title: 'Nhóm món',
                      ),
                      child: StatCard(
                        title: 'Số nhóm món',
                        value: '$groups',
                        icon: Icons.category_rounded,
                        accentColor: AppColors.gold,
                      ),
                    ),
                    _ClickableStatCard(
                      onTap: () => _openRecipeList(
                        context,
                        status: RecipeStatus.ngungBan,
                        title: 'Món ngưng bán',
                      ),
                      child: StatCard(
                        title: 'Ngưng bán',
                        value: '$ngungBan',
                        icon: Icons.do_not_disturb_alt_rounded,
                        accentColor: AppColors.danger,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.touch_app_rounded, color: AppColors.coffeeBrown),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Nhấn vào từng thẻ thống kê để mở nhanh danh sách tương ứng.',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ClickableStatCard extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const _ClickableStatCard({
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: child,
      ),
    );
  }
}