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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureDefaultShiftGroups();
    });
  }

  String _groupId(String shift) {
    return 'report-template-${shift.toLowerCase().replaceAll(' ', '-')}';
  }

  Future<void> _ensureDefaultShiftGroups() async {
    final now = DateTime.now();

    for (final shift in _shifts) {
      final id = _groupId(shift);
      final existed = HiveService.reportBox.get(id);

      if (existed != null) continue;

      final session = ReportChecklistSession(
        id: id,
        shift: shift,
        workingDate: DateTime(2000, 1, 1),
        employeeName: '',
        items: buildReportItemsForShift(shift),
        createdAt: now,
      );

      await HiveService.reportBox.put(id, session);
    }

    if (mounted) setState(() {});
  }

  ReportChecklistSession? _getShiftSession(String shift) {
    return HiveService.reportBox.get(_groupId(shift));
  }

  void _openShiftDetail(String shift) {
    final session = _getShiftSession(shift);
    if (session == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReportChecklistDetailScreen(
          sessionId: session.id,
          shiftName: shift,
        ),
      ),
    ).then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final sessions = _shifts
        .map((shift) => _getShiftSession(shift))
        .whereType<ReportChecklistSession>()
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Checklist chụp báo cáo'),
      ),
      body: sessions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                const Text(
                  'Danh sách checklist theo ca',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Chọn ca để xem checklist đầu ca và cuối ca',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.coffeeDark,
                  ),
                ),
                const SizedBox(height: 18),

                ...sessions.map(
                  (session) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _ShiftCard(
                      session: session,
                      onTap: () => _openShiftDetail(session.shift),
                    ),
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

  const _ShiftCard({
    required this.session,
    required this.onTap,
  });

  int _countByTime(String timePoint) {
    return session.items.where((item) => item.timePoint == timePoint).length;
  }

  @override
  Widget build(BuildContext context) {
    final dauCa = _countByTime('Đầu ca');
    final cuoiCa = _countByTime('Cuối ca');

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.border),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 12,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: AppColors.goldSoft,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.assignment_rounded,
                  color: AppColors.coffeeBrown,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.shift,
                      style: const TextStyle(
                        color: AppColors.coffeeDark,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${session.items.length} mục checklist',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _SmallInfoChip(
                          icon: Icons.wb_sunny_outlined,
                          text: 'Đầu ca: $dauCa',
                        ),
                        _SmallInfoChip(
                          icon: Icons.nights_stay_outlined,
                          text: 'Cuối ca: $cuoiCa',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.coffeeBrown,
                size: 30,
              ),
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

  ReportChecklistSession? get _session {
    return HiveService.reportBox.get(widget.sessionId);
  }

  List<ReportChecklistItem> _itemsByGroup({
    required String timePoint,
    required String area,
  }) {
    final session = _session;
    if (session == null) return [];

    final list = session.items.where((item) {
      return item.timePoint == timePoint && item.area == area;
    }).toList();

    list.sort((a, b) => a.order.compareTo(b.order));
    return list;
  }

  Future<void> _addItem({
    required String timePoint,
    required String area,
  }) async {
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

    final newItem = ReportChecklistItem(
      id: '${widget.shiftName}-${DateTime.now().microsecondsSinceEpoch}',
      order: newOrder,
      shift: widget.shiftName,
      timePoint: result.timePoint,
      area: result.area,
      title: result.itemTitle,
      requirement: result.requirement,
    );

    session.items = [...items, newItem];
    session.updatedAt = DateTime.now();

    await session.save();

    if (!mounted) return;
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã thêm mục checklist')),
    );
  }

  Future<void> _editItem(ReportChecklistItem item) async {
    final result = await _showItemFormDialog(
      title: 'Sửa mục checklist',
      oldItem: item,
    );

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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã cập nhật mục checklist')),
    );
  }

  Future<void> _deleteItem(ReportChecklistItem item) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xoá mục này?'),
          content: Text('Bạn có chắc muốn xoá "${item.title}" không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Huỷ'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Xoá'),
            ),
          ],
        );
      },
    );

    if (ok != true) return;

    final session = _session;
    if (session == null) return;

    final items = [...session.items];
    items.removeWhere((e) => e.id == item.id);

    for (int i = 0; i < items.length; i++) {
      items[i].order = i + 1;
    }

    session.items = items;
    session.updatedAt = DateTime.now();

    await session.save();

    if (!mounted) return;
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã xoá mục checklist')),
    );
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
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: itemTitleController,
                      decoration: const InputDecoration(
                        labelText: 'Tên mục cần chụp',
                        hintText: 'Ví dụ: Chụp báo cáo doanh số',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: requirementController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Yêu cầu',
                        hintText: 'Ví dụ: Chụp rõ số liệu cuối ca',
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedTimePoint,
                      decoration: const InputDecoration(
                        labelText: 'Thời điểm',
                      ),
                      items: timeGroups.map((time) {
                        return DropdownMenuItem(
                          value: time,
                          child: Text(time),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setDialogState(() => selectedTimePoint = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedArea,
                      decoration: const InputDecoration(
                        labelText: 'Khu vực',
                      ),
                      items: areaGroups.map((area) {
                        return DropdownMenuItem(
                          value: area,
                          child: Text(area),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setDialogState(() => selectedArea = value);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Huỷ'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final itemTitle = itemTitleController.text.trim();
                    final requirement = requirementController.text.trim();

                    if (itemTitle.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tên mục không được để trống')),
                      );
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
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = _session;

    if (session == null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.shiftName)),
        body: const Center(
          child: Text('Không tìm thấy dữ liệu checklist'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Checklist ${widget.shiftName}'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          const Text(
            'Danh sách được chia theo thời điểm và khu vực',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),

          ...timeGroups.map((timePoint) {
            return _TimeGroupSection(
              title: timePoint,
              icon: timePoint == 'Đầu ca'
                  ? Icons.wb_sunny_outlined
                  : Icons.nights_stay_outlined,
              children: areaGroups.map((area) {
                final items = _itemsByGroup(
                  timePoint: timePoint,
                  area: area,
                );

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _AreaGroupSection(
                    area: area,
                    items: items,
                    onAdd: () => _addItem(
                      timePoint: timePoint,
                      area: area,
                    ),
                    onEdit: _editItem,
                    onDelete: _deleteItem,
                  ),
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

  const _TimeGroupSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        iconColor: AppColors.coffeeBrown,
        collapsedIconColor: AppColors.coffeeBrown,
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.goldSoft,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: AppColors.coffeeBrown,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.coffeeDark,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        children: children,
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
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: ExpansionTile(
        initiallyExpanded: items.isNotEmpty,
        tilePadding: const EdgeInsets.symmetric(horizontal: 14),
        childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        iconColor: AppColors.coffeeBrown,
        collapsedIconColor: AppColors.coffeeBrown,
        leading: Icon(
          isInside ? Icons.countertops_outlined : Icons.storefront_outlined,
          color: AppColors.coffeeBrown,
        ),
        title: Text(
          area,
          style: const TextStyle(
            color: AppColors.coffeeDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${items.length} mục',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        trailing: IconButton(
          tooltip: 'Thêm mục',
          onPressed: onAdd,
          icon: const Icon(
            Icons.add_circle_outline_rounded,
            color: AppColors.coffeeBrown,
          ),
        ),
        children: [
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _EmptyAreaBox(onAdd: onAdd),
            )
          else
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ChecklistViewCard(
                  item: item,
                  onEdit: () => onEdit(item),
                  onDelete: () => onDelete(item),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyAreaBox extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyAreaBox({
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Text(
            'Chưa có mục checklist',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Thêm mục'),
          ),
        ],
      ),
    );
  }
}

class _ChecklistViewCard extends StatelessWidget {
  final ReportChecklistItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ChecklistViewCard({
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 6, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.goldSoft,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Center(
                child: Text(
                  '${item.order}',
                  style: const TextStyle(
                    color: AppColors.coffeeDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: AppColors.coffeeDark,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.requirement,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') onEdit();
                if (value == 'delete') onDelete();
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, size: 19),
                      SizedBox(width: 8),
                      Text('Sửa'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, size: 19, color: AppColors.danger),
                      SizedBox(width: 8),
                      Text('Xoá'),
                    ],
                  ),
                ),
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

  const _SmallInfoChip({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: AppColors.coffeeBrown,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.coffeeDark,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
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