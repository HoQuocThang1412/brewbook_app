import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../models/recipe.dart';
import '../services/hive_service.dart';
import '../theme/app_colors.dart';
import '../widgets/stat_card.dart';
import '../widgets/status_badge.dart';
import 'recipe_detail_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('☕ Ứng dụng quản lý công thức pha chế'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                DateFormat('dd/MM/yyyy').format(DateTime.now()),
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: HiveService.listenable(),
        builder: (context, Box<Recipe> box, _) {
          final total = HiveService.totalRecipes;
          final dangBan = HiveService.totalDangBan;
          final groups = HiveService.totalCategories;
          final recent = HiveService.recentRecipes;

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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.coffeeDark),
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
                    StatCard(
                      title: 'Tổng số công thức',
                      value: '$total',
                      icon: Icons.menu_book_rounded,
                      accentColor: AppColors.coffeeBrown,
                    ),
                    StatCard(
                      title: 'Món đang bán',
                      value: '$dangBan',
                      icon: Icons.local_cafe_rounded,
                      accentColor: AppColors.success,
                    ),
                    StatCard(
                      title: 'Số nhóm món',
                      value: '$groups',
                      icon: Icons.category_rounded,
                      accentColor: AppColors.gold,
                    ),
                    StatCard(
                      title: 'Ngưng bán',
                      value: '${total - dangBan}',
                      icon: Icons.do_not_disturb_alt_rounded,
                      accentColor: AppColors.danger,
                    ),
                  ],
                ),
                const SizedBox(height: 26),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Món mới thêm gần đây',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.coffeeDark),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (recent.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text('Chưa có công thức nào', style: TextStyle(color: AppColors.textSecondary)),
                    ),
                  )
                else
                  ...recent.map((r) => _RecentRecipeTile(recipe: r)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _RecentRecipeTile extends StatelessWidget {
  final Recipe recipe;
  const _RecentRecipeTile({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(color: AppColors.goldSoft, borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.local_cafe_rounded, color: AppColors.coffeeBrown, size: 20),
        ),
        title: Text(recipe.name, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.coffeeDark)),
        subtitle: Text(recipe.category, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5)),
        trailing: StatusBadge(status: recipe.status),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipeId: recipe.id)),
        ),
      ),
    );
  }
}
