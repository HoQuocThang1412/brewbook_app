import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/recipe.dart';
import '../services/hive_service.dart';
import '../services/recipe_excel_export_service.dart';
import '../theme/app_colors.dart';
import '../widgets/confirm_delete_dialog.dart';
import '../widgets/recipe_card.dart';
import '../widgets/empty_state.dart';
import 'recipe_detail_screen.dart';
import 'recipe_form_screen.dart';

const _baseIngredientCategory = 'Nguyên liệu nền';

class RecipeListScreen extends StatefulWidget {
  final String? initialCategory;
  final String? initialStatus;
  final bool showCategorySummary;
  final String? pageTitle;

  const RecipeListScreen({
    super.key,
    this.initialCategory,
    this.initialStatus,
    this.showCategorySummary = false,
    this.pageTitle,
  });

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  String _searchText = '';
  String? _selectedCategory;
  String? _selectedStatus;
  bool _showCategorySummary = false;
  bool _showBaseIngredients = false;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _showBaseIngredients = widget.initialCategory == _baseIngredientCategory;
    _selectedCategory = _showBaseIngredients ? null : widget.initialCategory;
    _selectedStatus = widget.initialStatus;
    _showCategorySummary = widget.showCategorySummary;
  }

  void _onAdd() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => RecipeFormScreen(
          initialCategory: _showBaseIngredients ? _baseIngredientCategory : null,
        ),
      ),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_showBaseIngredients ? 'Đã thêm nguyên liệu nền thành công' : 'Đã thêm công thức mới thành công'),
        ),
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

  void _onDelete(Recipe recipe) async {
    final confirmed = await showConfirmDeleteDialog(context, itemName: recipe.name);
    if (!confirmed) return;

    await HiveService.deleteRecipe(recipe.id);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã xoá "${recipe.name}" thành công')),
    );
  }

  void _onView(Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipeId: recipe.id)),
    );
  }

  Future<void> _onExportExcel() async {
    if (_isExporting) return;

    setState(() => _isExporting = true);
    try {
      await exportRecipesToExcel();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã xuất Excel thành công')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Chưa xuất được Excel: $e')),
      );
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Map<String, int> _getCategoryCounts(List<Recipe> recipes) {
    final result = <String, int>{};

    for (final recipe in recipes) {
      final category = recipe.category.trim();
      if (category.isEmpty) continue;
      result[category] = (result[category] ?? 0) + 1;
    }

    return result;
  }

  List<String> _getCategories(List<Recipe> recipes) {
    final categories = recipes
        .map((r) => r.category.trim())
        .where((category) => category.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
    return categories;
  }

  void _clearFilters() {
    setState(() {
      _searchText = '';
      _selectedCategory = null;
      _selectedStatus = null;
      _showCategorySummary = false;
    });
  }

  void _changeSection(bool showBaseIngredients) {
    if (_showBaseIngredients == showBaseIngredients) return;
    setState(() {
      _showBaseIngredients = showBaseIngredients;
      _selectedCategory = null;
      _selectedStatus = null;
      _showCategorySummary = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.pageTitle ?? 'Công thức pha chế';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            tooltip: 'Xuất Excel',
            onPressed: _isExporting ? null : _onExportExcel,
            icon: _isExporting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.file_download_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onAdd,
        icon: const Icon(Icons.add_rounded),
        label: Text(_showBaseIngredients ? 'Thêm nguyên liệu' : 'Thêm công thức'),
      ),
      body: ValueListenableBuilder(
        valueListenable: HiveService.listenable(),
        builder: (context, Box<Recipe> box, _) {
          final allRecipes = HiveService.getAllRecipes();
          final baseRecipes = allRecipes.where((r) => r.category == _baseIngredientCategory).toList();
          final drinkRecipes = allRecipes.where((r) => r.category != _baseIngredientCategory).toList();
          final sectionRecipes = _showBaseIngredients ? baseRecipes : drinkRecipes;
          final categories = _getCategories(sectionRecipes);
          final categoryCounts = _getCategoryCounts(sectionRecipes);

          List<Recipe> recipes = sectionRecipes;

          if (_searchText.trim().isNotEmpty) {
            final q = _searchText.trim().toLowerCase();
            recipes = recipes.where((r) {
              return r.name.toLowerCase().contains(q) || r.category.toLowerCase().contains(q);
            }).toList();
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
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: _showBaseIngredients ? 'Tìm nguyên liệu nền...' : 'Tìm theo tên món hoặc nhóm món...',
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
                    isDense: true,
                  ),
                  onChanged: (v) => setState(() => _searchText = v),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: _RecipeSectionTabs(
                  showBaseIngredients: _showBaseIngredients,
                  drinkCount: drinkRecipes.length,
                  baseCount: baseRecipes.length,
                  onChanged: _changeSection,
                ),
              ),

              SizedBox(
                height: 42,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _FilterDropdown(
                      label: _showBaseIngredients ? 'Loại nguyên liệu' : 'Nhóm món',
                      value: _selectedCategory,
                      items: categories,
                      onChanged: (v) => setState(() {
                        _selectedCategory = v;
                        _showCategorySummary = v == null ? _showCategorySummary : false;
                      }),
                    ),
                    const SizedBox(width: 10),
                    _FilterDropdown(
                      label: 'Trạng thái',
                      value: _selectedStatus,
                      items: RecipeStatus.all,
                      onChanged: (v) => setState(() {
                        _selectedStatus = v;
                      }),
                    ),
                    const SizedBox(width: 10),
                    _ClearFilterButton(onTap: _clearFilters),
                  ],
                ),
              ),

              if (_showCategorySummary) ...[
                const SizedBox(height: 12),
                _CategorySummary(
                  categoryCounts: categoryCounts,
                  selectedCategory: _selectedCategory,
                  onSelected: (category) {
                    setState(() {
                      _selectedCategory = category;
                      _showCategorySummary = false;
                    });
                  },
                ),
              ],

              const SizedBox(height: 8),

              Expanded(
                child: recipes.isEmpty
                    ? const EmptyState(message: 'Không tìm thấy công thức phù hợp')
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 96),
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

class _RecipeSectionTabs extends StatelessWidget {
  final bool showBaseIngredients;
  final int drinkCount;
  final int baseCount;
  final ValueChanged<bool> onChanged;

  const _RecipeSectionTabs({
    required this.showBaseIngredients,
    required this.drinkCount,
    required this.baseCount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _TabButton(
            label: 'Món pha chế',
            count: drinkCount,
            icon: Icons.local_cafe_rounded,
            selected: !showBaseIngredients,
            onTap: () => onChanged(false),
          ),
          const SizedBox(width: 4),
          _TabButton(
            label: 'Nguyên liệu nền',
            count: baseCount,
            icon: Icons.science_outlined,
            selected: showBaseIngredients,
            onTap: () => onChanged(true),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.count,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: selected ? AppColors.surface : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 17, color: selected ? AppColors.coffeeBrown : AppColors.textSecondary),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    '$label ($count)',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                      color: selected ? AppColors.coffeeDark : AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
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
          hint: Text(
            label,
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18,
            color: AppColors.coffeeBrown,
          ),
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.coffeeDark,
            fontWeight: FontWeight.w600,
          ),
          items: [
            DropdownMenuItem<String?>(
              value: null,
              child: Text('Tất cả $label'),
            ),
            ...items.map(
              (e) => DropdownMenuItem<String?>(
                value: e,
                child: Text(e),
              ),
            ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _ClearFilterButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ClearFilterButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: const Row(
            children: [
              Icon(Icons.refresh_rounded, size: 17, color: AppColors.coffeeBrown),
              SizedBox(width: 5),
              Text(
                'Bỏ lọc',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.coffeeDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategorySummary extends StatelessWidget {
  final Map<String, int> categoryCounts;
  final String? selectedCategory;
  final ValueChanged<String> onSelected;

  const _CategorySummary({
    required this.categoryCounts,
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (categoryCounts.isEmpty) {
      return const SizedBox.shrink();
    }

    final entries = categoryCounts.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Danh sách nhóm món',
            style: TextStyle(
              color: AppColors.coffeeDark,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: entries.map((entry) {
              final active = selectedCategory == entry.key;

              return ChoiceChip(
                selected: active,
                label: Text('${entry.key} (${entry.value})'),
                onSelected: (_) => onSelected(entry.key),
                selectedColor: AppColors.goldSoft,
                backgroundColor: AppColors.surfaceAlt,
                labelStyle: TextStyle(
                  color: active ? AppColors.coffeeDark : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
                side: BorderSide(
                  color: active ? AppColors.gold : AppColors.border,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
