import 'package:hive/hive.dart';

import '../models/ingredient.dart';
import '../models/recipe.dart';

const recoveredRecipeSeedVersion = 'recovered_test_recipes_v1';

Future<int> seedRecoveredTestRecipes(Box<Recipe> box) async {
  final recipes = _buildRecoveredRecipes();

  for (final recipe in recipes) {
    final duplicateKeys = box.keys.where((key) {
      final existing = box.get(key);
      return existing != null && existing.name.trim().toLowerCase() == recipe.name.trim().toLowerCase();
    }).toList();

    for (final key in duplicateKeys) {
      await box.delete(key);
    }

    await box.put(recipe.id, recipe);
  }

  return recipes.length;
}

List<Recipe> _buildRecoveredRecipes() {
  final now = DateTime.now();

  return [
    Recipe(
      id: 'recovered-cacao-da-xay',
      name: 'Cacao đá xay',
      category: 'Đá xay',
      cup: 'Ly nhựa 500ml',
      status: RecipeStatus.ngungBan,
      ingredients: [
        Ingredient(name: 'Bột cacao', quantity: 20, unit: 'g'),
        Ingredient(name: 'Sữa tươi', quantity: 150, unit: 'ml'),
        Ingredient(name: 'Kem béo', quantity: 30, unit: 'ml'),
        Ingredient(name: 'Đá viên', quantity: 200, unit: 'g'),
        Ingredient(name: 'Kem tươi', quantity: 20, unit: 'g'),
      ],
      steps: const [
        'Cho bột cacao, sữa tươi, kem béo và đá viên vào máy xay sinh tố.',
        'Xay nhuyễn đến khi hỗn hợp mịn và sánh.',
        'Đổ ra ly, bơm kem tươi lên trên và rắc thêm chút bột cacao.',
      ],
      note: 'Tạm ngưng bán do đang điều chỉnh lại công thức kem béo.',
      createdAt: now,
      updatedAt: now,
    ),
    Recipe(
      id: 'recovered-bac-xiu',
      name: 'Bạc xỉu',
      category: 'Cà phê',
      cup: 'Ly nhựa 350ml',
      status: RecipeStatus.dangBan,
      ingredients: [
        Ingredient(name: 'Cà phê phin', quantity: 15, unit: 'g'),
        Ingredient(name: 'Sữa tươi', quantity: 100, unit: 'ml'),
        Ingredient(name: 'Sữa đặc', quantity: 20, unit: 'ml'),
        Ingredient(name: 'Đá viên', quantity: 150, unit: 'g'),
      ],
      steps: const [
        'Pha cà phê phin với 60ml nước sôi.',
        'Cho sữa đặc và sữa tươi vào ly, khuấy tan đều.',
        'Đổ cà phê đã pha vào, thêm đá viên đầy ly.',
      ],
      note: 'Tỷ lệ sữa nhiều hơn cà phê sữa đá thông thường, vị béo nhẹ.',
      createdAt: now,
      updatedAt: now,
    ),
    Recipe(
      id: 'recovered-matcha-latte',
      name: 'Matcha Latte',
      category: 'Trà sữa',
      cup: 'Ly nhựa 450ml',
      status: RecipeStatus.dangBan,
      ingredients: [
        Ingredient(name: 'Bột matcha', quantity: 10, unit: 'g'),
        Ingredient(name: 'Sữa tươi', quantity: 200, unit: 'ml'),
        Ingredient(name: 'Đường nước', quantity: 15, unit: 'ml'),
        Ingredient(name: 'Đá viên', quantity: 150, unit: 'g'),
      ],
      steps: const [
        'Rây bột matcha cho mịn, hòa với 30ml nước ấm và đánh tan không vón cục.',
        'Cho đường nước vào ly, thêm đá viên rồi đến sữa tươi.',
        'Rót hỗn hợp matcha lên trên cùng, khuấy nhẹ trước khi dùng.',
      ],
      note: 'Nên dùng matcha nguyên chất để tránh vị đắng gắt và lên màu đẹp.',
      createdAt: now,
      updatedAt: now,
    ),
    Recipe(
      id: 'recovered-ca-phe-sua-da',
      name: 'Cà phê sữa đá',
      category: 'Cà phê',
      cup: 'Ly nhựa 350ml',
      status: RecipeStatus.dangBan,
      ingredients: [
        Ingredient(name: 'Cà phê phin', quantity: 25, unit: 'g'),
        Ingredient(name: 'Sữa đặc', quantity: 30, unit: 'ml'),
        Ingredient(name: 'Đá viên', quantity: 150, unit: 'g'),
      ],
      steps: const [
        'Pha cà phê phin với 80ml nước sôi, chờ cà phê nhỏ giọt hết.',
        'Cho sữa đặc vào ly, đổ cà phê vào và khuấy đều cho tan.',
        'Thêm đá viên đầy ly và thưởng thức.',
      ],
      note: 'Có thể điều chỉnh lượng sữa đặc theo khẩu vị khách.',
      createdAt: now,
      updatedAt: now,
    ),
  ];
}
