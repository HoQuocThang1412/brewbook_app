import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../theme/app_colors.dart';
import 'status_badge.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onView,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: Offset(0, 5)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.goldSoft,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.local_cafe_rounded, color: AppColors.coffeeBrown),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.coffeeDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${recipe.category} · ${recipe.cup}',
                        style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                StatusBadge(status: recipe.status),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.list_alt_rounded, size: 16, color: AppColors.textSecondary.withOpacity(0.8)),
                const SizedBox(width: 4),
                Text(
                  '${recipe.ingredients.length} nguyên liệu · ${recipe.steps.length} bước',
                  style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: AppColors.border),
            const SizedBox(height: 8),
            Row(
              children: [
                _ActionButton(icon: Icons.visibility_outlined, label: 'Xem', onTap: onView),
                const SizedBox(width: 6),
                _ActionButton(icon: Icons.edit_outlined, label: 'Sửa', onTap: onEdit),
                const SizedBox(width: 6),
                _ActionButton(
                  icon: Icons.delete_outline_rounded,
                  label: 'Xoá',
                  onTap: onDelete,
                  color: AppColors.danger,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = AppColors.coffeeBrown,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 17, color: color),
              const SizedBox(width: 5),
              Text(label, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
