import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/recipe.dart';
import '../models/ingredient.dart';
import 'sample_data.dart';

/// Service trung tâm thao tác với Hive (lưu trữ local, hoạt động offline 100%).
class HiveService {
  static const String recipeBoxName = 'recipes_box';
  static Box<Recipe>? _box;

  /// Gọi 1 lần khi khởi động app (trong main()).
  static Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(RecipeAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(IngredientAdapter());
    }

    _box = await Hive.openBox<Recipe>(recipeBoxName);

    // Nếu box rỗng (lần đầu cài app) -> nạp 5 món mẫu.
    if (_box!.isEmpty) {
      await seedSampleData(_box!);
    }
  }

  static Box<Recipe> get box {
    final b = _box;
    if (b == null) {
      throw StateError('HiveService chưa được khởi tạo. Hãy gọi HiveService.init() trong main().');
    }
    return b;
  }

  /// Dùng để lắng nghe thay đổi real-time với ValueListenableBuilder.
  static ValueListenable<Box<Recipe>> listenable() => box.listenable();

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

  static Recipe? getRecipe(String id) => box.get(id);

  static List<String> getAllCategories() {
    final categories = box.values.map((r) => r.category.trim()).where((c) => c.isNotEmpty).toSet().toList();
    categories.sort();
    return categories;
  }

  // ---- Thống kê cho trang Tổng quan ----

  static int get totalRecipes => box.values.length;

  static int get totalDangBan => box.values.where((r) => r.dangBan).length;

  static int get totalCategories => getAllCategories().length;

  static List<Recipe> get recentRecipes {
    final list = getAllRecipes();
    return list.take(5).toList();
  }
}
