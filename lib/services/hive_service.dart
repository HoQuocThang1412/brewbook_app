import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/recipe.dart';
import '../models/ingredient.dart';
import '../models/report_checklist.dart';
import '../models/work_process.dart';

import 'sample_data.dart';
import 'report_checklist_templates.dart';
import 'work_process_templates.dart';

class HiveService {
  static const String recipeBoxName = 'recipes_box';
  static const String reportChecklistBoxName = 'report_checklists_box';
  static const String workProcessBoxName = 'work_process_box';

  static Box<Recipe>? _recipeBox;
  static Box<ReportChecklistSession>? _reportChecklistBox;
  static Box<WorkProcessItem>? _workProcessBox;

  static Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(RecipeAdapter());
    }

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(IngredientAdapter());
    }

    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(ReportChecklistItemAdapter());
    }

    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(ReportChecklistSessionAdapter());
    }

    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(WorkProcessItemAdapter());
    }

    _recipeBox = await Hive.openBox<Recipe>(recipeBoxName);
    _reportChecklistBox = await Hive.openBox<ReportChecklistSession>(reportChecklistBoxName);
    _workProcessBox = await Hive.openBox<WorkProcessItem>(workProcessBoxName);

    if (_recipeBox!.isEmpty) {
      await seedSampleData(_recipeBox!);
    }

    if (_workProcessBox!.isEmpty) {
      await seedDefaultWorkProcessData();
    }
  }

  // ============================================================
  // CÔNG THỨC PHA CHẾ
  // ============================================================

  static Box<Recipe> get box {
    final b = _recipeBox;
    if (b == null) {
      throw StateError('HiveService chưa được khởi tạo.');
    }
    return b;
  }

  static ValueListenable<Box<Recipe>> listenable() {
    return box.listenable();
  }

  static List<Recipe> getAllRecipes() {
    final list = box.values.toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  static Future<void> addRecipe(Recipe recipe) async {
    await box.put(recipe.id, recipe);
  }

  static Future<void> updateRecipe(Recipe recipe) async {
    recipe.updatedAt = DateTime.now();
    await recipe.save();
  }

  static Future<void> deleteRecipe(String id) async {
    await box.delete(id);
  }

  static Recipe? getRecipe(String id) {
    return box.get(id);
  }

  static List<String> getAllCategories() {
    final categories = box.values
        .map((recipe) => recipe.category.trim())
        .where((category) => category.isNotEmpty)
        .toSet()
        .toList();

    categories.sort();
    return categories;
  }

  static int get totalRecipes {
    return box.values.length;
  }

  static int get totalDangBan {
    return box.values.where((recipe) => recipe.dangBan).length;
  }

  static int get totalCategories {
    return getAllCategories().length;
  }

  static List<Recipe> get recentRecipes {
    final list = getAllRecipes();
    return list.take(5).toList();
  }

  // ============================================================
  // CHECKLIST CHỤP BÁO CÁO
  // ============================================================

  static Box<ReportChecklistSession> get reportBox {
    final b = _reportChecklistBox;
    if (b == null) {
      throw StateError('HiveService chưa được khởi tạo reportBox.');
    }
    return b;
  }

  static ValueListenable<Box<ReportChecklistSession>> reportListenable() {
    return reportBox.listenable();
  }

  static List<ReportChecklistSession> getAllReportSessions() {
    final list = reportBox.values.toList();

    list.sort((a, b) {
      final dateCompare = b.workingDate.compareTo(a.workingDate);
      if (dateCompare != 0) return dateCompare;
      return b.createdAt.compareTo(a.createdAt);
    });

    return list;
  }

  static ReportChecklistSession? getReportSession(String id) {
    return reportBox.get(id);
  }

  static ReportChecklistSession? getSessionByShiftAndDate({
    required String shift,
    required DateTime date,
  }) {
    for (final session in reportBox.values) {
      if (session.shift == shift && _sameDate(session.workingDate, date)) {
        return session;
      }
    }

    return null;
  }

  static Future<ReportChecklistSession> createReportSession({
    required String shift,
    required DateTime workingDate,
    String employeeName = '',
  }) async {
    final existed = getSessionByShiftAndDate(
      shift: shift,
      date: workingDate,
    );

    if (existed != null) return existed;

    final now = DateTime.now();

    final id =
        'report-${shift.replaceAll(' ', '-')}-${workingDate.year}${workingDate.month}${workingDate.day}-${now.microsecondsSinceEpoch}';

    final session = ReportChecklistSession(
      id: id,
      shift: shift,
      workingDate: DateTime(
        workingDate.year,
        workingDate.month,
        workingDate.day,
      ),
      employeeName: employeeName.trim(),
      items: buildReportItemsForShift(shift),
      createdAt: now,
    );

    await reportBox.put(session.id, session);
    return session;
  }

  static Future<void> deleteReportSession(String id) async {
    await reportBox.delete(id);
  }

  static Future<void> updateReportEmployeeName({
    required String sessionId,
    required String employeeName,
  }) async {
    final session = reportBox.get(sessionId);
    if (session == null) return;

    session.employeeName = employeeName.trim();
    session.updatedAt = DateTime.now();

    await session.save();
  }

  static Future<void> toggleReportItem({
    required String sessionId,
    required String itemId,
    required bool isDone,
  }) async {
    final session = reportBox.get(sessionId);
    if (session == null) return;

    final index = session.items.indexWhere((item) => item.id == itemId);
    if (index == -1) return;

    final oldItem = session.items[index];

    session.items[index] = oldItem.copyWith(
      isDone: isDone,
      completedAt: isDone ? DateTime.now() : null,
      clearCompletedAt: !isDone,
    );

    session.updatedAt = DateTime.now();

    await session.save();
  }

  static Future<void> updateReportItemNote({
    required String sessionId,
    required String itemId,
    required String note,
  }) async {
    final session = reportBox.get(sessionId);
    if (session == null) return;

    final index = session.items.indexWhere((item) => item.id == itemId);
    if (index == -1) return;

    final oldItem = session.items[index];

    session.items[index] = oldItem.copyWith(
      note: note.trim(),
    );

    session.updatedAt = DateTime.now();

    await session.save();
  }

  static Future<void> resetReportSession(String sessionId) async {
    final session = reportBox.get(sessionId);
    if (session == null) return;

    session.items = session.items.map((item) {
      return item.copyWith(
        isDone: false,
        note: '',
        completedAt: null,
        clearCompletedAt: true,
      );
    }).toList();

    session.updatedAt = DateTime.now();

    await session.save();
  }

  // ============================================================
  // QUY TRÌNH LÀM VIỆC
  // ============================================================

  static Box<WorkProcessItem> get workProcessBox {
    final b = _workProcessBox;
    if (b == null) {
      throw StateError('HiveService chưa được khởi tạo workProcessBox.');
    }
    return b;
  }

  static ValueListenable<Box<WorkProcessItem>> workProcessListenable() {
    return workProcessBox.listenable();
  }

  static Future<void> seedDefaultWorkProcessData() async {
    final items = buildDefaultWorkProcessItems();

    for (final item in items) {
      await workProcessBox.put(item.id, item);
    }
  }

  static List<WorkProcessItem> getAllWorkProcessItems() {
    final list = workProcessBox.values.toList();
    list.sort(_compareWorkProcessItem);
    return list;
  }

  static List<WorkProcessItem> getWorkProcessItemsByShift(String shift) {
    final list = workProcessBox.values.where((item) {
      return item.shift == shift;
    }).toList();

    list.sort(_compareWorkProcessItem);
    return list;
  }

  static int getWorkProcessCountByShift(String shift) {
    return workProcessBox.values.where((item) {
      return item.shift == shift;
    }).length;
  }

  static int getGuidedCountByShift(String shift) {
    return workProcessBox.values.where((item) {
      return item.shift == shift && item.isGuided;
    }).length;
  }

  static int getNextWorkProcessOrder(String shift) {
    final list = getWorkProcessItemsByShift(shift);

    if (list.isEmpty) return 1;

    final maxOrder = list
        .map((item) => item.order)
        .reduce((a, b) => a > b ? a : b);

    return maxOrder + 1;
  }

  static Future<void> addWorkProcessItem(WorkProcessItem item) async {
    await workProcessBox.put(item.id, item);
  }

  static Future<void> updateWorkProcessItem(WorkProcessItem item) async {
    item.updatedAt = DateTime.now();
    await item.save();
  }

  static Future<void> deleteWorkProcessItem(String id) async {
    await workProcessBox.delete(id);
  }

  static Future<void> toggleWorkProcessGuided({
    required String id,
    required bool isGuided,
  }) async {
    final item = workProcessBox.get(id);
    if (item == null) return;

    item.isGuided = isGuided;
    item.updatedAt = DateTime.now();

    await item.save();
  }

  static int _compareWorkProcessItem(
    WorkProcessItem a,
    WorkProcessItem b,
  ) {
    final phaseCompare = _phaseRank(a.phase).compareTo(_phaseRank(b.phase));
    if (phaseCompare != 0) return phaseCompare;

    final areaCompare = a.area.compareTo(b.area);
    if (areaCompare != 0) return areaCompare;

    return a.order.compareTo(b.order);
  }

  static int _phaseRank(String phase) {
    switch (phase) {
      case 'Đầu ca':
        return 1;
      case 'Giữa ca':
        return 2;
      case 'Cuối ca':
        return 3;
      case 'Định kỳ':
        return 4;
      default:
        return 99;
    }
  }

  static bool _sameDate(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }
}