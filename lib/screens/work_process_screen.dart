import 'package:flutter/material.dart';

import '../models/work_process.dart';
import '../services/hive_service.dart';
import '../theme/app_colors.dart';

class WorkProcessScreen extends StatelessWidget {
  const WorkProcessScreen({super.key});

  static const List<String> shifts = ['Ca 1', 'Ca 2', 'Ca 3'];

  void _openShift(BuildContext context, String shift) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => WorkProcessShiftScreen(shiftName: shift)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Quy trình làm việc')),
      body: ValueListenableBuilder(
        valueListenable: HiveService.workProcessListenable(),
        builder: (context, box, _) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 104),
            children: [
              const Text(
                'Theo dõi hướng dẫn nhân viên theo từng ca',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 18),
              ...shifts.map((shift) {
                final total = HiveService.getWorkProcessCountByShift(shift);
                final guided = HiveService.getGuidedCountByShift(shift);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _ProcessMainCard(
                    title: shift,
                    subtitle: '$total công việc • đã hướng dẫn $guided/$total',
                    icon: Icons.assignment_ind_rounded,
                    progress: total == 0 ? 0 : guided / total,
                    onTap: () => _openShift(context, shift),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

class WorkProcessShiftScreen extends StatelessWidget {
  final String shiftName;

  const WorkProcessShiftScreen({super.key, required this.shiftName});

  static const List<String> phases = ['Đầu ca', 'Giữa ca', 'Cuối ca'];

  void _openPhase(BuildContext context, String phase) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => WorkProcessPhaseScreen(shiftName: shiftName, phaseName: phase)),
    );
  }

  int _count(List<WorkProcessItem> items, String phase) => items.where((item) => item.phase == phase).length;

  int _guided(List<WorkProcessItem> items, String phase) {
    return items.where((item) => item.phase == phase && item.isGuided).length;
  }

  IconData _icon(String phase) {
    switch (phase) {
      case 'Đầu ca':
        return Icons.wb_sunny_outlined;
      case 'Giữa ca':
        return Icons.coffee_maker_outlined;
      case 'Cuối ca':
        return Icons.nights_stay_outlined;
      default:
        return Icons.list_alt_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Quy trình $shiftName')),
      body: ValueListenableBuilder(
        valueListenable: HiveService.workProcessListenable(),
        builder: (context, box, _) {
          final items = HiveService.getWorkProcessItemsByShift(shiftName);
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
            children: [
              const Text('Chọn giai đoạn trong ca làm', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              const SizedBox(height: 18),
              ...phases.map((phase) {
                final total = _count(items, phase);
                final guided = _guided(items, phase);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _ProcessMainCard(
                    title: phase,
                    subtitle: '$total công việc • đã hướng dẫn $guided/$total',
                    icon: _icon(phase),
                    progress: total == 0 ? 0 : guided / total,
                    onTap: () => _openPhase(context, phase),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

class WorkProcessPhaseScreen extends StatefulWidget {
  final String shiftName;
  final String phaseName;

  const WorkProcessPhaseScreen({super.key, required this.shiftName, required this.phaseName});

  @override
  State<WorkProcessPhaseScreen> createState() => _WorkProcessPhaseScreenState();
}

class _WorkProcessPhaseScreenState extends State<WorkProcessPhaseScreen> {
  String _searchText = '';

  Future<void> _addItem() async {
    final result = await _showFormDialog(title: 'Thêm công việc');
    if (result == null) return;
    final now = DateTime.now();
    final item = WorkProcessItem(
      id: 'work-${widget.shiftName}-${now.microsecondsSinceEpoch}',
      order: HiveService.getNextWorkProcessOrder(widget.shiftName),
      shift: widget.shiftName,
      phase: widget.phaseName,
      area: result.area,
      task: result.task,
      assignee: result.assignee,
      isGuided: result.isGuided,
      note: result.note,
      isPeriodic: false,
      schedule: '',
      createdAt: now,
    );
    await HiveService.addWorkProcessItem(item);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã thêm công việc')));
  }

  Future<void> _editItem(WorkProcessItem item) async {
    final result = await _showFormDialog(title: 'Sửa công việc', oldItem: item);
    if (result == null) return;
    item.area = result.area;
    item.task = result.task;
    item.assignee = result.assignee;
    item.isGuided = result.isGuided;
    item.note = result.note;
    await HiveService.updateWorkProcessItem(item);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã cập nhật công việc')));
  }

  Future<void> _deleteItem(WorkProcessItem item) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xoá công việc?'),
        content: Text('Bạn có chắc muốn xoá "${item.task}" không?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Huỷ')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xoá'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await HiveService.deleteWorkProcessItem(item.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã xoá công việc')));
  }

  Future<_WorkFormResult?> _showFormDialog({required String title, WorkProcessItem? oldItem}) async {
    final areaController = TextEditingController(text: oldItem?.area ?? '');
    final taskController = TextEditingController(text: oldItem?.task ?? '');
    final assigneeController = TextEditingController(text: oldItem?.assignee ?? '');
    final noteController = TextEditingController(text: oldItem?.note ?? '');
    bool guided = oldItem?.isGuided ?? false;

    return showDialog<_WorkFormResult>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: areaController, decoration: const InputDecoration(labelText: 'Khu vực / Nhóm việc')),
                const SizedBox(height: 12),
                TextField(controller: taskController, maxLines: 3, decoration: const InputDecoration(labelText: 'Công việc')),
                const SizedBox(height: 12),
                TextField(controller: assigneeController, decoration: const InputDecoration(labelText: 'Người phụ trách')),
                const SizedBox(height: 8),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: guided,
                  activeColor: AppColors.success,
                  title: const Text('Đã được hướng dẫn'),
                  subtitle: const Text('Tích khi nhân viên mới đã được hướng dẫn'),
                  onChanged: (value) => setDialogState(() => guided = value ?? false),
                ),
                TextField(controller: noteController, maxLines: 2, decoration: const InputDecoration(labelText: 'Ghi chú')),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Huỷ')),
            ElevatedButton(
              onPressed: () {
                final task = taskController.text.trim();
                if (task.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Công việc không được để trống')));
                  return;
                }
                Navigator.pop(
                  context,
                  _WorkFormResult(
                    area: areaController.text.trim().isEmpty ? 'Chưa phân loại' : areaController.text.trim(),
                    task: task,
                    assignee: assigneeController.text.trim(),
                    isGuided: guided,
                    note: noteController.text.trim(),
                  ),
                );
              },
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleGuided(WorkProcessItem item, bool value) async {
    await HiveService.toggleWorkProcessGuided(id: item.id, isGuided: value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('${widget.shiftName} - ${widget.phaseName}')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addItem,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Thêm việc'),
      ),
      body: ValueListenableBuilder(
        valueListenable: HiveService.workProcessListenable(),
        builder: (context, box, _) {
          List<WorkProcessItem> items = HiveService
              .getWorkProcessItemsByShift(widget.shiftName)
              .where((item) => item.phase == widget.phaseName)
              .toList();
          if (_searchText.trim().isNotEmpty) {
            final q = _searchText.trim().toLowerCase();
            items = items.where((item) {
              return item.task.toLowerCase().contains(q) ||
                  item.area.toLowerCase().contains(q) ||
                  item.assignee.toLowerCase().contains(q);
            }).toList();
          }
          items.sort((a, b) => a.order.compareTo(b.order));
          final guided = items.where((item) => item.isGuided).length;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 104),
            children: [
              _WorkSummaryCard(total: items.length, guided: guided),
              const SizedBox(height: 14),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Tìm công việc, khu vực, người phụ trách...',
                  prefixIcon: Icon(Icons.search_rounded),
                  isDense: true,
                ),
                onChanged: (value) => setState(() => _searchText = value),
              ),
              const SizedBox(height: 16),
              if (items.isEmpty)
                _EmptyBox(onAdd: _addItem)
              else
                ...items.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _WorkItemTile(
                      item: item,
                      onToggle: (value) => _toggleGuided(item, value),
                      onEdit: () => _editItem(item),
                      onDelete: () => _deleteItem(item),
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}

class _ProcessMainCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final double progress;
  final VoidCallback onTap;

  const _ProcessMainCard({required this.title, required this.subtitle, required this.icon, required this.progress, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).round();
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
            boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 16, offset: Offset(0, 7))],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(color: AppColors.goldSoft, borderRadius: BorderRadius.circular(18)),
                child: Icon(icon, color: AppColors.coffeeBrown, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900, letterSpacing: -0.35)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13.5)),
                    const SizedBox(height: 10),
                    ClipRRect(borderRadius: BorderRadius.circular(999), child: LinearProgressIndicator(value: progress, minHeight: 7)),
                    const SizedBox(height: 5),
                    Text('$percent%', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.coffeeBrown),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorkSummaryCard extends StatelessWidget {
  final int total;
  final int guided;

  const _WorkSummaryCard({required this.total, required this.guided});

  @override
  Widget build(BuildContext context) {
    final percent = total == 0 ? 0 : ((guided / total) * 100).round();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
        boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 14, offset: Offset(0, 6))],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: AppColors.successSoft, borderRadius: BorderRadius.circular(15)),
            child: const Icon(Icons.school_rounded, color: AppColors.success),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Đã hướng dẫn $guided/$total công việc', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15.5)),
                const SizedBox(height: 3),
                Text('$percent% hoàn tất', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkItemTile extends StatelessWidget {
  final WorkProcessItem item;
  final ValueChanged<bool> onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _WorkItemTile({required this.item, required this.onToggle, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final assignee = item.assignee.trim().isEmpty ? 'Chưa phân công' : item.assignee.trim();
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: item.isGuided ? AppColors.success : AppColors.border, width: item.isGuided ? 1.25 : 1),
        boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: Offset(0, 5))],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 12, 4, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: item.isGuided,
              activeColor: AppColors.success,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              onChanged: (value) => onToggle(value ?? false),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.task,
                      style: TextStyle(
                        color: item.isGuided ? AppColors.success : AppColors.textPrimary,
                        fontSize: 16,
                        height: 1.32,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.15,
                        decoration: item.isGuided ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _MiniChip(icon: Icons.place_outlined, text: item.area),
                        _MiniChip(icon: Icons.person_outline_rounded, text: assignee),
                        _MiniChip(
                          icon: item.isGuided ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                          text: item.isGuided ? 'Đã hướng dẫn' : 'Chưa hướng dẫn',
                          success: item.isGuided,
                        ),
                      ],
                    ),
                    if (item.note.trim().isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(item.note.trim(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.35)),
                    ],
                  ],
                ),
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') onEdit();
                if (value == 'delete') onDelete();
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'edit', child: Text('Sửa')),
                PopupMenuItem(value: 'delete', child: Text('Xoá')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool success;

  const _MiniChip({required this.icon, required this.text, this.success = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(color: success ? AppColors.successSoft : AppColors.goldSoft, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: success ? AppColors.success : AppColors.coffeeBrown),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              color: success ? AppColors.success : AppColors.textPrimary,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyBox extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyBox({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(22), border: Border.all(color: AppColors.border)),
      child: Column(
        children: [
          const Icon(Icons.assignment_outlined, size: 46, color: AppColors.textSecondary),
          const SizedBox(height: 10),
          const Text('Chưa có công việc nào', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          const Text('Bấm thêm việc để tạo quy trình cho phần này.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 14),
          ElevatedButton.icon(onPressed: onAdd, icon: const Icon(Icons.add_rounded), label: const Text('Thêm việc')),
        ],
      ),
    );
  }
}

class _WorkFormResult {
  final String area;
  final String task;
  final String assignee;
  final bool isGuided;
  final String note;

  const _WorkFormResult({required this.area, required this.task, required this.assignee, required this.isGuided, required this.note});
}
