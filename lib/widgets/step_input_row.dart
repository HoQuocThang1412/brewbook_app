import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class StepInputRow extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onRemove;
  final int index;

  const StepInputRow({
    super.key,
    required this.controller,
    required this.onRemove,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 26,
            height: 26,
            decoration: const BoxDecoration(color: AppColors.coffeeBrown, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(
              '${index + 1}',
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: controller,
              minLines: 1,
              maxLines: 3,
              decoration: InputDecoration(labelText: 'Bước ${index + 1}', isDense: true),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Nhập nội dung bước' : null,
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.close_rounded, color: AppColors.danger, size: 20),
            tooltip: 'Xoá bước',
          ),
        ],
      ),
    );
  }
}
