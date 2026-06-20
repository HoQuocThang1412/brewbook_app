import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class IngredientInputRow extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController quantityController;
  final TextEditingController unitController;
  final VoidCallback onRemove;
  final int index;

  const IngredientInputRow({
    super.key,
    required this.nameController,
    required this.quantityController,
    required this.unitController,
    required this.onRemove,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 14, right: 8),
            child: Text('${index + 1}', style: const TextStyle(color: AppColors.coffeeLight, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 4,
            child: TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Tên nguyên liệu', isDense: true),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Nhập tên' : null,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: quantityController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'SL', isDense: true),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'SL?';
                if (double.tryParse(v.replaceAll(',', '.')) == null) return 'Sai';
                return null;
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: unitController,
              decoration: const InputDecoration(labelText: 'Đơn vị', isDense: true),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'ĐV?' : null,
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.close_rounded, color: AppColors.danger, size: 20),
            tooltip: 'Xoá nguyên liệu',
          ),
        ],
      ),
    );
  }
}
