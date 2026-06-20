import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/recipe.dart';
import '../services/hive_service.dart';
import '../theme/app_colors.dart';
import '../widgets/premium_motion.dart';
import '../widgets/stat_card.dart';
import 'recipe_list_screen.dart';
import 'report_checklist_screen.dart';
import 'work_process_screen.dart';

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

  void _openPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: ValueListenableBuilder(
          valueListenable: HiveService.listenable(),
          builder: (context, Box<Recipe> box, _) {
            final total = HiveService.totalRecipes;
            final dangBan = HiveService.totalDangBan;
            final groups = HiveService.totalCategories;
            final ngungBan = total - dangBan;

            return RefreshIndicator(
              onRefresh: () async {},
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 104),
                children: [
                  const FadeSlideIn(child: _DashboardHeader()),
                  const SizedBox(height: 16),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 70),
                    child: _OverviewCard(total: total, active: dangBan, groups: groups),
                  ),
                  const SizedBox(height: 22),
                  const _SectionHeader(title: 'Chức năng chính', subtitle: 'Các mục dùng thường xuyên'),
                  const SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final wide = constraints.maxWidth >= 720;
                      return GridView.count(
                        crossAxisCount: wide ? 4 : 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: wide ? 1.18 : 1.08,
                        children: [
                          _FeatureCard(
                            icon: Icons.local_cafe_rounded,
                            title: 'Công thức',
                            subtitle: 'Quản lý món nước',
                            onTap: () => _openRecipeList(context, title: 'Tất cả công thức'),
                          ),
                          _FeatureCard(
                            icon: Icons.fact_check_rounded,
                            title: 'Checklist',
                            subtitle: 'Chụp báo cáo theo ca',
                            onTap: () => _openPage(context, const ReportChecklistScreen()),
                          ),
                          _FeatureCard(
                            icon: Icons.assignment_ind_rounded,
                            title: 'Quy trình',
                            subtitle: 'Hướng dẫn nhân viên',
                            onTap: () => _openPage(context, const WorkProcessScreen()),
                          ),
                          _FeatureCard(
                            icon: Icons.category_rounded,
                            title: 'Nhóm món',
                            subtitle: '$groups nhóm hiện có',
                            onTap: () => _openRecipeList(
                              context,
                              showCategorySummary: true,
                              title: 'Nhóm món',
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 22),
                  const _SectionHeader(title: 'Tổng quan dữ liệu', subtitle: 'Theo dõi nhanh tình trạng món'),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.25,
                    children: [
                      _TapCard(
                        onTap: () => _openRecipeList(context, title: 'Tất cả công thức'),
                        child: StatCard(
                          title: 'Tổng công thức',
                          value: '$total',
                          icon: Icons.menu_book_rounded,
                          accentColor: AppColors.coffeeBrown,
                        ),
                      ),
                      _TapCard(
                        onTap: () => _openRecipeList(
                          context,
                          status: RecipeStatus.dangBan,
                          title: 'Món đang bán',
                        ),
                        child: StatCard(
                          title: 'Đang bán',
                          value: '$dangBan',
                          icon: Icons.check_circle_rounded,
                          accentColor: AppColors.success,
                        ),
                      ),
                      _TapCard(
                        onTap: () => _openRecipeList(
                          context,
                          showCategorySummary: true,
                          title: 'Nhóm món',
                        ),
                        child: StatCard(
                          title: 'Nhóm món',
                          value: '$groups',
                          icon: Icons.grid_view_rounded,
                          accentColor: AppColors.gold,
                        ),
                      ),
                      _TapCard(
                        onTap: () => _openRecipeList(
                          context,
                          status: RecipeStatus.ngungBan,
                          title: 'Món ngưng bán',
                        ),
                        child: StatCard(
                          title: 'Ngưng bán',
                          value: '$ngungBan',
                          icon: Icons.pause_circle_rounded,
                          accentColor: AppColors.danger,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: Offset(0, 5))],
          ),
          child: const Icon(Icons.coffee_rounded, color: AppColors.coffeeBrown),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BrewBook',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5),
              ),
              SizedBox(height: 2),
              Text(
                'Quản lý pha chế gọn gàng hơn mỗi ca',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Làm mới',
          onPressed: () {},
          icon: const Icon(Icons.refresh_rounded),
        ),
      ],
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final int total;
  final int active;
  final int groups;

  const _OverviewCard({required this.total, required this.active, required this.groups});

  @override
  Widget build(BuildContext context) {
    final ratio = total == 0 ? 0.0 : active / total;
    final percent = (ratio * 100).round();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.border),
        boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 18, offset: Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.goldSoft,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Tổng quan hôm nay',
                  style: TextStyle(color: AppColors.coffeeBrown, fontWeight: FontWeight.w800, fontSize: 12),
                ),
              ),
              const Spacer(),
              const Icon(Icons.insights_rounded, color: AppColors.coffeeBrown),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'Sẵn sàng cho ca làm',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, letterSpacing: -0.7),
          ),
          const SizedBox(height: 8),
          Text(
            '$active món đang bán trong tổng $total công thức. Dữ liệu được chia thành $groups nhóm món.',
            style: const TextStyle(color: AppColors.textSecondary, height: 1.45),
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(value: ratio, minHeight: 8),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text('$percent% món đang bán', style: const TextStyle(fontWeight: FontWeight.w800)),
              const Spacer(),
              Text('$groups nhóm', style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.2)),
        const SizedBox(height: 3),
        Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _TapCard(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.border),
          boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 14, offset: Offset(0, 6))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: AppColors.coffeeBrown),
            ),
            const Spacer(),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5, height: 1.25),
            ),
          ],
        ),
      ),
    );
  }
}

class _TapCard extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const _TapCard({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: child,
      ),
    );
  }
}
