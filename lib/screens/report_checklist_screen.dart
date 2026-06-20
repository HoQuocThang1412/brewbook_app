import 'package:flutter/material.dart';

import '../models/report_checklist.dart';
import '../services/hive_service.dart';
import '../services/report_checklist_templates.dart';
import '../theme/app_colors.dart';

class ReportChecklistScreen extends StatefulWidget {
  const ReportChecklistScreen({super.key});

  @override
  State<ReportChecklistScreen> createState() => _ReportChecklistScreenState();
}

class _ReportChecklistScreenState extends State<ReportChecklistScreen> {
  final List<String> _shifts = const ['Ca 1', 'Ca 2', 'Ca 3'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureDefaultShiftGroups());
  }

  String _groupId(String shift) => 'report-template-${shift.toLowerCase().replaceAll(' ', '-')}';

  Future<void> _ensureDefaultShiftGroups() async {
    final now = DateTime.now();
    for (final shift in _shifts) {
      final id = _groupId(shift);
      if (HiveService.reportBox.get(id) != null) continue;
      await HiveService.reportBox.put(
        id,
        ReportChecklistSession(
          id: id,
          shift: shift,
          workingDate: DateTime(2000, 1, 1),
          employeeName: '',
          items: buildReportItemsForShift(shift),
          createdAt: now,
        ),
      );
    }
    if (mounted) setState(() {});
  }

  ReportChecklistSession? _getShiftSession(String shift) => HiveService.reportBox.get(_groupId(shift));

  void _openShiftDetail(String shift) {
    final session = _getShiftSession(shift);
    if (session == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReportChecklistDetailScreen(sessionId: session.id, shiftName: shift),
      ),
    ).then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final sessions = _shifts.map(_getShiftSession).whereType<ReportChecklistSession>().toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Checklist chụp báo cáo')),
      body: sessions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 104),
              children: [
                const Text(
                  'Theo dõi ảnh báo cáo theo từng ca làm',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 18),
                ...sessions.map(
                  (session) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _ShiftCard(session: session, onTap: () => _openShiftDetail(session.shift)),
                  ),
                ),
              ],
            ),
    );
  }
}

class _ShiftCard extends StatelessWidget {
  final ReportChecklistSession session;
  final VoidCallback onTap;

  const _ShiftCard({required this.session, required this.onTap});

  int _countByTime(String timePoint) => session.items.where((item) => item.timePoint == timePoint).length;

  @override
  Widget build(BuildContext context) {
    final dauCa = _countByTime('Đầu ca');
    final cuoiCa = _countByTime('Cuối ca');

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(26),
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: AppColors.border),
            boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 18, offset: Offset(0, 8))],
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(color: AppColors.goldSoft, borderRadius: BorderRadius.circular(20)),
                child: const Icon(Icons.assignment_rounded, color: AppColors.coffeeBrown, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.shift,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 22,
                        height: 1.1,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${session.items.length} mục checklist',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _SmallInfoChip(icon: Icons.wb_sunny_outlined, text: 'Đầu ca: $dauCa'),
                        _SmallInfoChip(icon: Icons.nights_stay_outlined, text: 'Cuối ca: $cuoiCa'),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.coffeeBrown, size: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class ReportChecklistDetailScreen extends StatefulWidget {
  final String sessionId;
  final String shiftName;

  const ReportChecklistDetailScreen({
    super.key,
    required this.sessionId,
    required this.shiftName,
  });

  @override
  State<ReportChecklistDetailScreen> createState() => _ReportChecklistDetailScreenState();
}

class _ReportChecklistDetailScreenState extends State<ReportChecklistDetailScreen> {
  static const List<String> timeGroups = ['Đầu ca', 'Cuối ca'];
  static const List<String> areaGroups = ['Khu vực trong quầy', 'Khu vực ngoài'];

  ReportChecklistSession? get _session => HiveService.reportBox.get(widget.sessionId);

  List<ReportChecklistItem> _itemsByGroup({required String timePoint, required String area}) {
    final session = _session;
    if (session == null) return [];
    final list = session.items.where((item) => item.timePoint == timePoint && item.area == area).toList();
    list.sort((a, b) => a.order.compareTo(b.order));
    return list;
  }

  Future<void> _addItem({required String timePoint, required String area}) async {
    final result = await _showItemFormDialog(
      title: 'Thêm mục checklist',
      defaultTimePoint: timePoint,
      defaultArea: area,
    );
    if (result == null) return;

    final session = _session;
    if (session == null) return;
    final items = [...session.items]..sort((a, b) => a.order.compareTo(b.order));
    final newOrder = items.isEmpty ? 1 : items.last.order + 1;

    session.items = [
      ...items,
      ReportChecklistItem(
        id: '${widget.shiftName}-${DateTime.now().microsecondsSinceEpoch}',
        order: newOrder,
        shift: widget.shiftName,
        timePoint: result.timePoint,
        area: result.area,
        title: result.itemTitle,
        requirement: result.requirement,
      ),
    ];
    session.updatedAt = DateTime.now();
    await session.save();

    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã thêm mục checklist')));
  }

  Future<void> _editItem(ReportChecklistItem item) async {
    final result = await _showItemFormDialog(title: 'Sửa mục checklist', oldItem: item);
    if (result == null) return;

    final session = _session;
    if (session == null) return;
    final index = session.items.indexWhere((e) => e.id == item.id);
    if (index == -1) return;

    session.items[index] = item.copyWith(
      title: result.itemTitle,
      requirement: result.requirement,
      timePoint: result.timePoint,
      area: result.area,
    );
    session.updatedAt = DateTime.now();
    await session.save();

    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã cập nhật mục checklist')));
  }

  Future<void> _deleteItem(ReportChecklistItem item) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xoá mục này?'),
        content: Text('Bạn có chắc muốn xoá "${item.title}" không?'),
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

    final session = _session;
    if (session == null) return;
    final items = [...session.items]..removeWhere((e) => e.id == item.id);
    for (int i = 0; i < items.length; i++) {
      items[i].order = i + 1;
    }
    session.items = items;
    session.updatedAt = DateTime.now();
    await session.save();

    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã xoá mục checklist')));
  }

  Future<_ChecklistFormResult?> _showItemFormDialog({
    required String title,
    ReportChecklistItem? oldItem,
    String defaultTimePoint = 'Cuối ca',
    String defaultArea = 'Khu vực trong quầy',
  }) async {
    final itemTitleController = TextEditingController(text: oldItem?.title ?? '');
    final requirementController = TextEditingController(text: oldItem?.requirement ?? '');
    String selectedTimePoint = oldItem?.timePoint ?? defaultTimePoint;
    String selectedArea = oldItem?.area ?? defaultArea;

    return showDialog<_ChecklistFormResult>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: itemTitleController,
                  decoration: const InputDecoration(labelText: 'Tên mục cần chụp'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: requirementController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Yêu cầu', hintText: 'Ví dụ: Chụp rõ số liệu cuối ca'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedTimePoint,
                  decoration: const InputDecoration(labelText: 'Thời điểm'),
                  items: timeGroups.map((time) => DropdownMenuItem(value: time, child: Text(time))).toList(),
                  onChanged: (value) {
                    if (value != null) setDialogState(() => selectedTimePoint = value);
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedArea,
                  decoration: const InputDecoration(labelText: 'Khu vực'),
                  items: areaGroups.map((area) => DropdownMenuItem(value: area, child: Text(area))).toList(),
                  onChanged: (value) {
                    if (value != null) setDialogState(() => selectedArea = value);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Huỷ')),
            ElevatedButton(
              onPressed: () {
                final itemTitle = itemTitleController.text.trim();
                final requirement = requirementController.text.trim();
                if (itemTitle.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tên mục không được để trống')));
                  return;
                }
                Navigator.pop(
                  context,
                  _ChecklistFormResult(
                    itemTitle: itemTitle,
                    requirement: requirement.isEmpty ? 'Chưa nhập yêu cầu' : requirement,
                    timePoint: selectedTimePoint,
                    area: selectedArea,
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

  @override
  Widget build(BuildContext context) {
    final session = _session;
    if (session == null) {
      return Scaffold(appBar: AppBar(title: Text(widget.shiftName)), body: const Center(child: Text('Không tìm thấy dữ liệu checklist')));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Checklist ${widget.shiftName}')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
        children: [
          Text(
            'Chia theo thời điểm và khu vực để dễ kiểm tra ảnh báo cáo.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          ...timeGroups.map((timePoint) {
            final icon = timePoint == 'Đầu ca' ? Icons.wb_sunny_outlined : Icons.nights_stay_outlined;
            return _TimeGroupSection(
              title: timePoint,
              icon: icon,
              children: areaGroups.map((area) {
                final items = _itemsByGroup(timePoint: timePoint, area: area);
                return _AreaGroupSection(
                  area: area,
                  items: items,
                  onAdd: () => _addItem(timePoint: timePoint, area: area),
                  onEdit: _editItem,
                  onDelete: _deleteItem,
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }
}

class _TimeGroupSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _TimeGroupSection({required this.title, required this.icon, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 16, offset: Offset(0, 7))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(color: AppColors.goldSoft, borderRadius: BorderRadius.circular(14)),
                child: Icon(icon, color: AppColors.coffeeBrown, size: 21),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, letterSpacing: -0.25),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _AreaGroupSection extends StatelessWidget {
  final String area;
  final List<ReportChecklistItem> items;
  final VoidCallback onAdd;
  final ValueChanged<ReportChecklistItem> onEdit;
  final ValueChanged<ReportChecklistItem> onDelete;

  const _AreaGroupSection({
    required this.area,
    required this.items,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isInside = area == 'Khu vực trong quầy';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: items.isNotEmpty,
          tilePadding: const EdgeInsets.fromLTRB(14, 2, 8, 2),
          childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          leading: Icon(isInside ? Icons.countertops_outlined : Icons.storefront_outlined, color: AppColors.coffeeBrown),
          title: Text(area, style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: -0.1)),
          subtitle: Text('${items.length} mục', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5)),
          trailing: IconButton(
            tooltip: 'Thêm mục',
            onPressed: onAdd,
            icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.coffeeBrown),
          ),
          children: [
            if (items.isEmpty)
              _EmptyAreaBox(onAdd: onAdd)
            else
              ...items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _ChecklistViewCard(item: item, onEdit: () => onEdit(item), onDelete: () => onDelete(item)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EmptyAreaBox extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyAreaBox({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Column(
        children: [
          const Text('Chưa có mục checklist', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(height: 8),
          OutlinedButton.icon(onPressed: onAdd, icon: const Icon(Icons.add_rounded, size: 18), label: const Text('Thêm mục')),
        ],
      ),
    );
  }
}

class _ChecklistViewCard extends StatelessWidget {
  final ReportChecklistItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ChecklistViewCard({required this.item, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.border)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(13, 13, 6, 13),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(color: AppColors.goldSoft, borderRadius: BorderRadius.circular(12)),
              child: Center(child: Text('${item.order}', style: const TextStyle(color: AppColors.coffeeBrown, fontWeight: FontWeight.w800))),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: const TextStyle(fontSize: 15, height: 1.28, fontWeight: FontWeight.w800, letterSpacing: -0.1)),
                  const SizedBox(height: 6),
                  Text(item.requirement, style: const TextStyle(color: AppColors.textSecondary, height: 1.38, fontSize: 13)),
                ],
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

class _SmallInfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _SmallInfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(color: AppColors.goldSoft, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.coffeeBrown),
          const SizedBox(width: 5),
          Text(text, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12.5, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _ChecklistFormResult {
  final String itemTitle;
  final String requirement;
  final String timePoint;
  final String area;

  const _ChecklistFormResult({
    required this.itemTitle,
    required this.requirement,
    required this.timePoint,
    required this.area,
  });
}
