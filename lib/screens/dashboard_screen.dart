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
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 104),
                children: [
                  const FadeSlideIn(child: _TopBar()),
                  const SizedBox(height: 18),
                  const FadeSlideIn(
                    delay: Duration(milliseconds: 80),
                    child: _HeroPanel(),
                  ),
                  const SizedBox(height: 16),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 140),
                    child: _StatusPanel(
                      total: total,
                      dangBan: dangBan,
                      groups: groups,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const _SectionTitle(title: 'Truy cập nhanh', subtitle: 'Chạm để mở chức năng'),
                  const SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final wide = constraints.maxWidth > 620;
                      return GridView.count(
                        crossAxisCount: wide ? 4 : 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: wide ? 1.08 : 1.02,
                        children: [
                          FadeSlideIn(
                            delay: const Duration(milliseconds: 180),
                            child: _FeatureCard(
                              title: 'Công thức',
                              subtitle: '$total món đang lưu',
                              icon: Icons.local_cafe_rounded,
                              onTap: () => _openRecipeList(context, title: 'Tất cả công thức'),
                            ),
                          ),
                          FadeSlideIn(
                            delay: const Duration(milliseconds: 230),
                            child: _FeatureCard(
                              title: 'Checklist',
                              subtitle: 'Chụp báo cáo theo ca',
                              icon: Icons.fact_check_rounded,
                              onTap: () => _openPage(context, const ReportChecklistScreen()),
                            ),
                          ),
                          FadeSlideIn(
                            delay: const Duration(milliseconds: 280),
                            child: _FeatureCard(
                              title: 'Quy trình',
                              subtitle: 'Hướng dẫn nhân viên',
                              icon: Icons.route_rounded,
                              onTap: () => _openPage(context, const WorkProcessScreen()),
                            ),
                          ),
                          FadeSlideIn(
                            delay: const Duration(milliseconds: 330),
                            child: _FeatureCard(
                              title: 'Nhóm món',
                              subtitle: '$groups nhóm hiện có',
                              icon: Icons.category_rounded,
                              onTap: () => _openRecipeList(
                                context,
                                showCategorySummary: true,
                                title: 'Nhóm món',
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  const _SectionTitle(title: 'Thống kê quán', subtitle: 'Tình trạng công thức hiện tại'),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.18,
                    children: [
                      PressScale(
                        onTap: () => _openRecipeList(context, title: 'Tất cả công thức'),
                        child: StatCard(
                          title: 'Tổng công thức',
                          value: '$total',
                          icon: Icons.menu_book_rounded,
                          accentColor: AppColors.coffeeBrown,
                        ),
                      ),
                      PressScale(
                        onTap: () => _openRecipeList(
                          context,
                          status: RecipeStatus.dangBan,
                          title: 'Món đang bán',
                        ),
                        child: StatCard(
                          title: 'Món đang bán',
                          value: '$dangBan',
                          icon: Icons.local_fire_department_rounded,
                          accentColor: AppColors.success,
                        ),
                      ),
                      PressScale(
                        onTap: () => _openRecipeList(
                          context,
                          showCategorySummary: true,
                          title: 'Nhóm món',
                        ),
                        child: StatCard(
                          title: 'Số nhóm món',
                          value: '$groups',
                          icon: Icons.grid_view_rounded,
                          accentColor: AppColors.gold,
                        ),
                      ),
                      PressScale(
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: const Icon(Icons.coffee_maker_rounded, color: AppColors.coffeeBrown),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('BrewBook', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              SizedBox(height: 2),
              Text('Premium workspace', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_rounded),
        ),
      ],
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.border),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF303433), Color(0xFF171A1A)],
        ),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 28, offset: Offset(0, 14)),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -26,
            child: Icon(
              Icons.local_cafe_rounded,
              size: 190,
              color: AppColors.textPrimary.withOpacity(0.08),
            ),
          ),
          Positioned(
            right: 10,
            top: 30,
            child: Container(
              width: 108,
              height: 108,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.coffeeBrown.withOpacity(0.16),
              ),
              child: const Icon(Icons.coffee_rounded, size: 58, color: AppColors.coffeeBrown),
            ),
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StatusPill(),
              Spacer(),
              Text(
                'BREW\nREADY',
                style: TextStyle(
                  fontSize: 50,
                  height: 0.9,
                  letterSpacing: -2.2,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Quản lý công thức, checklist báo cáo và quy trình ca làm trong một giao diện gọn đẹp.',
                style: TextStyle(color: AppColors.textSecondary, height: 1.35),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.goldSoft,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border),
      ),
      child: const Text(
        'Check Status',
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.coffeeBrown),
      ),
    );
  }
}

class _StatusPanel extends StatelessWidget {
  final int total;
  final int dangBan;
  final int groups;

  const _StatusPanel({required this.total, required this.dangBan, required this.groups});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.insights_rounded, color: AppColors.coffeeBrown),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$dangBan / $total món đang bán',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
          ),
          Text('$groups nhóm', style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        const SizedBox(height: 3),
        Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PressScale(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.textPrimary, size: 30),
            const Spacer(),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
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
