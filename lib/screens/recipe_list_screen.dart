import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/recipe.dart';
import '../services/hive_service.dart';
import '../theme/app_colors.dart';
import '../widgets/recipe_card.dart';
import '../widgets/confirm_delete_dialog.dart';
import '../widgets/empty_state.dart';
import 'recipe_detail_screen.dart';
import 'recipe_form_screen.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  String _searchText = '';
  String? _selectedCategory; // null = Tất cả
  String? _selectedStatus; // null = Tất cả

  void _onDelete(Recipe recipe) async {
    final confirmed = await showConfirmDeleteDialog(context, itemName: recipe.name);
    if (!confirmed) return;
    await HiveService.deleteRecipe(recipe.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã xoá "${recipe.name}" thành công')),
    );
  }

  void _onAdd() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const RecipeFormScreen()),
    );
    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã thêm công thức mới thành công')),
      );
    }
  }

  void _onEdit(Recipe recipe) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => RecipeFormScreen(recipeId: recipe.id)),
    );
    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã cập nhật công thức thành công')),
      );
    }
  }

  void _onView(Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipeId: recipe.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Công thức pha chế')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onAdd,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Thêm công thức'),
      ),
      body: ValueListenableBuilder(
        valueListenable: HiveService.listenable(),
        builder: (context, Box<Recipe> box, _) {
          final categories = HiveService.getAllCategories();

          List<Recipe> recipes = HiveService.getAllRecipes();

          if (_searchText.trim().isNotEmpty) {
            final q = _searchText.trim().toLowerCase();
            recipes = recipes.where((r) => r.name.toLowerCase().contains(q)).toList();
          }
          if (_selectedCategory != null) {
            recipes = recipes.where((r) => r.category == _selectedCategory).toList();
          }
          if (_selectedStatus != null) {
            recipes = recipes.where((r) => r.status == _selectedStatus).toList();
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm theo tên món...',
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
                    isDense: true,
                  ),
                  onChanged: (v) => setState(() => _searchText = v),
                ),
              ),
              SizedBox(
                height: 42,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _FilterDropdown(
                      label: 'Nhóm món',
                      value: _selectedCategory,
                      items: categories,
                      onChanged: (v) => setState(() => _selectedCategory = v),
                    ),
                    const SizedBox(width: 10),
                    _FilterDropdown(
                      label: 'Trạng thái',
                      value: _selectedStatus,
                      items: RecipeStatus.all,
                      onChanged: (v) => setState(() => _selectedStatus = v),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: recipes.isEmpty
                    ? const EmptyState(message: 'Không tìm thấy công thức phù hợp')
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 90),
                        itemCount: recipes.length,
                        itemBuilder: (context, i) {
                          final r = recipes[i];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: RecipeCard(
                              recipe: r,
                              onView: () => _onView(r),
                              onEdit: () => _onEdit(r),
                              onDelete: () => _onDelete(r),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _FilterDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool active = value != null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: active ? AppColors.goldSoft : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: active ? AppColors.gold : AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: value,
          hint: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppColors.coffeeBrown),
          style: const TextStyle(fontSize: 13, color: AppColors.coffeeDark, fontWeight: FontWeight.w600),
          items: [
            DropdownMenuItem<String?>(value: null, child: Text('Tất cả $label')),
            ...items.map((e) => DropdownMenuItem<String?>(value: e, child: Text(e))),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}
