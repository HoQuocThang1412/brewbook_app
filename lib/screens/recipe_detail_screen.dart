import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/recipe.dart';
import '../services/hive_service.dart';
import '../theme/app_colors.dart';
import '../widgets/status_badge.dart';
import '../widgets/confirm_delete_dialog.dart';
import 'recipe_form_screen.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String recipeId;
  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final recipe = HiveService.getRecipe(widget.recipeId);

    if (recipe == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chi tiết công thức')),
        body: const Center(child: Text('Công thức không tồn tại hoặc đã bị xoá.')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Chi tiết công thức'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Sửa',
            onPressed: () async {
              final result = await Navigator.push<bool>(
                context,
                MaterialPageRoute(builder: (_) => RecipeFormScreen(recipeId: recipe.id)),
              );
              if (result == true && mounted) setState(() {});
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.danger),
            tooltip: 'Xoá',
            onPressed: () async {
              final confirmed = await showConfirmDeleteDialog(context, itemName: recipe.name);
              if (!confirmed) return;
              await HiveService.deleteRecipe(recipe.id);
              if (!mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đã xoá "${recipe.name}" thành công')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(color: AppColors.goldSoft, borderRadius: BorderRadius.circular(18)),
                child: const Icon(Icons.local_cafe_rounded, color: AppColors.coffeeBrown, size: 30),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(recipe.name,
                        style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: AppColors.coffeeDark)),
                    const SizedBox(height: 6),
                    StatusBadge(status: recipe.status),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _InfoChipsRow(recipe: recipe),
          const SizedBox(height: 22),
          _SectionCard(
            title: 'Nguyên liệu',
            icon: Icons.shopping_basket_outlined,
            child: Column(
              children: recipe.ingredients
                  .map(
                    (ing) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Icon(Icons.circle, size: 6, color: AppColors.coffeeBrown),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${ing.name} — ${_formatNumber(ing.quantity)} ${ing.unit}',
                              style: const TextStyle(fontSize: 14.5, color: AppColors.textPrimary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Cách pha chế',
            icon: Icons.format_list_numbered_rounded,
            child: Column(
              children: List.generate(recipe.steps.length, (i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(color: AppColors.coffeeBrown, shape: BoxShape.circle),
                        alignment: Alignment.center,
                        child: Text('${i + 1}',
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(recipe.steps[i],
                            style: const TextStyle(fontSize: 14.5, color: AppColors.textPrimary, height: 1.4)),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          if (recipe.note.trim().isNotEmpty) ...[
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Ghi chú',
              icon: Icons.sticky_note_2_outlined,
              child: Text(recipe.note, style: const TextStyle(fontSize: 14.5, color: AppColors.textPrimary, height: 1.4)),
            ),
          ],
          const SizedBox(height: 16),
          Text(
            'Cập nhật lần cuối: ${DateFormat('HH:mm dd/MM/yyyy').format(recipe.updatedAt)}',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  String _formatNumber(double v) {
    if (v == v.roundToDouble()) return v.toInt().toString();
    return v.toString();
  }
}

class _InfoChipsRow extends StatelessWidget {
  final Recipe recipe;
  const _InfoChipsRow({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _InfoChip(icon: Icons.category_outlined, label: recipe.category),
        _InfoChip(icon: Icons.local_drink_outlined, label: recipe.cup),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.coffeeBrown),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.coffeeDark, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  const _SectionCard({required this.title, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.gold),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: AppColors.coffeeDark)),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
