import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/recipe.dart';
import '../models/ingredient.dart';
import '../services/hive_service.dart';
import '../theme/app_colors.dart';
import '../widgets/ingredient_input_row.dart';
import '../widgets/step_input_row.dart';

const _uuid = Uuid();

class RecipeFormScreen extends StatefulWidget {
  /// Nếu null -> chế độ Thêm mới. Nếu có giá trị -> chế độ Sửa.
  final String? recipeId;
  const RecipeFormScreen({super.key, this.recipeId});

  @override
  State<RecipeFormScreen> createState() => _RecipeFormScreenState();
}

class _IngredientControllers {
  final TextEditingController name;
  final TextEditingController quantity;
  final TextEditingController unit;
  _IngredientControllers({String name = '', String quantity = '', String unit = ''})
      : name = TextEditingController(text: name),
        quantity = TextEditingController(text: quantity),
        unit = TextEditingController(text: unit);

  void dispose() {
    name.dispose();
    quantity.dispose();
    unit.dispose();
  }
}

class _RecipeFormScreenState extends State<RecipeFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;
  late TextEditingController _categoryCtrl;
  late TextEditingController _cupCtrl;
  late TextEditingController _noteCtrl;
  String _status = RecipeStatus.dangBan;

  final List<_IngredientControllers> _ingredientCtrls = [];
  final List<TextEditingController> _stepCtrls = [];

  bool get isEditing => widget.recipeId != null;
  Recipe? _existing;

  @override
  void initState() {
    super.initState();
    _existing = widget.recipeId != null ? HiveService.getRecipe(widget.recipeId!) : null;

    _nameCtrl = TextEditingController(text: _existing?.name ?? '');
    _categoryCtrl = TextEditingController(text: _existing?.category ?? '');
    _cupCtrl = TextEditingController(text: _existing?.cup ?? '');
    _noteCtrl = TextEditingController(text: _existing?.note ?? '');
    _status = _existing?.status ?? RecipeStatus.dangBan;

    if (_existing != null) {
      for (final ing in _existing!.ingredients) {
        _ingredientCtrls.add(_IngredientControllers(
          name: ing.name,
          quantity: _formatNumber(ing.quantity),
          unit: ing.unit,
        ));
      }
      for (final step in _existing!.steps) {
        _stepCtrls.add(TextEditingController(text: step));
      }
    }

    if (_ingredientCtrls.isEmpty) _ingredientCtrls.add(_IngredientControllers());
    if (_stepCtrls.isEmpty) _stepCtrls.add(TextEditingController());
  }

  String _formatNumber(double v) => v == v.roundToDouble() ? v.toInt().toString() : v.toString();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _categoryCtrl.dispose();
    _cupCtrl.dispose();
    _noteCtrl.dispose();
    for (final c in _ingredientCtrls) {
      c.dispose();
    }
    for (final c in _stepCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  void _addIngredientRow() => setState(() => _ingredientCtrls.add(_IngredientControllers()));

  void _removeIngredientRow(int index) {
    if (_ingredientCtrls.length == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Công thức cần ít nhất 1 nguyên liệu')),
      );
      return;
    }
    setState(() {
      _ingredientCtrls[index].dispose();
      _ingredientCtrls.removeAt(index);
    });
  }

  void _addStepRow() => setState(() => _stepCtrls.add(TextEditingController()));

  void _removeStepRow(int index) {
    if (_stepCtrls.length == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Công thức cần ít nhất 1 bước pha chế')),
      );
      return;
    }
    setState(() {
      _stepCtrls[index].dispose();
      _stepCtrls.removeAt(index);
    });
  }

  Future<void> _save() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng kiểm tra lại các trường thông tin')),
      );
      return;
    }

    final ingredients = _ingredientCtrls
        .map((c) => Ingredient(
              name: c.name.text.trim(),
              quantity: double.parse(c.quantity.text.trim().replaceAll(',', '.')),
              unit: c.unit.text.trim(),
            ))
        .toList();

    final steps = _stepCtrls.map((c) => c.text.trim()).where((s) => s.isNotEmpty).toList();

    if (isEditing && _existing != null) {
      _existing!
        ..name = _nameCtrl.text.trim()
        ..category = _categoryCtrl.text.trim()
        ..cup = _cupCtrl.text.trim()
        ..status = _status
        ..ingredients = ingredients
        ..steps = steps
        ..note = _noteCtrl.text.trim();
      await HiveService.updateRecipe(_existing!);
    } else {
      final recipe = Recipe(
        id: _uuid.v4(),
        name: _nameCtrl.text.trim(),
        category: _categoryCtrl.text.trim(),
        cup: _cupCtrl.text.trim(),
        status: _status,
        ingredients: ingredients,
        steps: steps,
        note: _noteCtrl.text.trim(),
        createdAt: DateTime.now(),
      );
      await HiveService.addRecipe(recipe);
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  void _cancel() => Navigator.pop(context, false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(isEditing ? 'Sửa công thức' : 'Thêm công thức mới')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
          children: [
            _Label('Tên món'),
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(hintText: 'Ví dụ: Cà phê sữa đá'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Vui lòng nhập tên món' : null,
            ),
            const SizedBox(height: 16),
            _Label('Nhóm món'),
            TextFormField(
              controller: _categoryCtrl,
              decoration: const InputDecoration(hintText: 'Ví dụ: Cà phê, Trà sữa, Đá xay...'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Vui lòng nhập nhóm món' : null,
            ),
            const SizedBox(height: 16),
            _Label('Ly sử dụng'),
            TextFormField(
              controller: _cupCtrl,
              decoration: const InputDecoration(hintText: 'Ví dụ: Ly nhựa 350ml'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Vui lòng nhập loại ly' : null,
            ),
            const SizedBox(height: 16),
            _Label('Trạng thái'),
            Row(
              children: RecipeStatus.all.map((s) {
                final selected = _status == s;
                final isActive = s == RecipeStatus.dangBan;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ChoiceChip(
                    label: Text(s),
                    selected: selected,
                    onSelected: (_) => setState(() => _status = s),
                    selectedColor: isActive ? AppColors.successSoft : AppColors.dangerSoft,
                    labelStyle: TextStyle(
                      color: selected ? (isActive ? AppColors.success : AppColors.danger) : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                    backgroundColor: AppColors.surface,
                    side: BorderSide(color: selected ? Colors.transparent : AppColors.border),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _Label('Nguyên liệu'),
                TextButton.icon(
                  onPressed: _addIngredientRow,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Thêm nguyên liệu'),
                ),
              ],
            ),
            ...List.generate(_ingredientCtrls.length, (i) {
              final c = _ingredientCtrls[i];
              return IngredientInputRow(
                index: i,
                nameController: c.name,
                quantityController: c.quantity,
                unitController: c.unit,
                onRemove: () => _removeIngredientRow(i),
              );
            }),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _Label('Các bước pha chế'),
                TextButton.icon(
                  onPressed: _addStepRow,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Thêm bước'),
                ),
              ],
            ),
            ...List.generate(_stepCtrls.length, (i) {
              return StepInputRow(
                index: i,
                controller: _stepCtrls[i],
                onRemove: () => _removeStepRow(i),
              );
            }),
            const SizedBox(height: 10),
            _Label('Ghi chú'),
            TextFormField(
              controller: _noteCtrl,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(hintText: 'Ghi chú thêm về công thức (không bắt buộc)'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        decoration: BoxDecoration(
          color: AppColors.background,
          boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 10, offset: Offset(0, -2))],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _cancel,
                child: const Text('Huỷ'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check_rounded),
                label: const Text('Lưu công thức'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: AppColors.coffeeDark),
      ),
    );
  }
}
