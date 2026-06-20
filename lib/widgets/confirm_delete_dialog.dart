import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Hiển thị hộp thoại xác nhận xoá. Trả về true nếu người dùng đồng ý xoá.
Future<bool> showConfirmDeleteDialog(BuildContext context, {required String itemName}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      icon: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.dangerSoft,
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: AppColors.danger, size: 28),
      ),
      title: const Text('Xác nhận xoá', textAlign: TextAlign.center),
      content: Text(
        'Bạn có chắc chắn muốn xoá "$itemName"?\nHành động này không thể hoàn tác.',
        textAlign: TextAlign.center,
        style: const TextStyle(color: AppColors.textSecondary),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Huỷ'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text('Xoá'),
        ),
      ],
    ),
  );
  return result ?? false;
}
