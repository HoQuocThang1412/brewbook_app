import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/recipe.dart';
import '../models/ingredient.dart';

const _uuid = Uuid();

Future<void> seedSampleData(Box<Recipe> box) async {
  final now = DateTime.now();

  final samples = <Recipe>[
    Recipe(
      id: _uuid.v4(),
      name: 'Cà phê sữa đá',
      category: 'Cà phê',
      cup: 'Ly nhựa 350ml',
      status: RecipeStatus.dangBan,
      ingredients: [
        Ingredient(name: 'Cà phê phin', quantity: 25, unit: 'g'),
        Ingredient(name: 'Sữa đặc', quantity: 30, unit: 'ml'),
        Ingredient(name: 'Đá viên', quantity: 150, unit: 'g'),
      ],
      steps: [
        'Pha cà phê phin với 80ml nước sôi, chờ cà phê nhỏ giọt hết.',
        'Cho sữa đặc vào ly, đổ cà phê vào và khuấy đều cho tan.',
        'Thêm đá viên đầy ly và thưởng thức.',
      ],
      note: 'Có thể điều chỉnh lượng sữa đặc theo khẩu vị khách.',
      createdAt: now.subtract(const Duration(days: 5)),
    ),
    Recipe(
      id: _uuid.v4(),
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
      steps: [
        'Pha cà phê phin với 60ml nước sôi.',
        'Cho sữa đặc và sữa tươi vào ly, khuấy tan đều.',
        'Đổ cà phê đã pha vào, thêm đá viên đầy ly.',
      ],
      note: 'Tỷ lệ sữa nhiều hơn cà phê sữa đá thông thường, vị béo nhẹ.',
      createdAt: now.subtract(const Duration(days: 4)),
    ),
    Recipe(
      id: _uuid.v4(),
      name: 'Trà đào cam sả',
      category: 'Trà trái cây',
      cup: 'Ly nhựa 500ml',
      status: RecipeStatus.dangBan,
      ingredients: [
        Ingredient(name: 'Trà đen', quantity: 1, unit: 'gói'),
        Ingredient(name: 'Đào ngâm', quantity: 3, unit: 'miếng'),
        Ingredient(name: 'Nước cốt đào', quantity: 30, unit: 'ml'),
        Ingredient(name: 'Cam tươi', quantity: 0.5, unit: 'quả'),
        Ingredient(name: 'Sả', quantity: 1, unit: 'nhánh'),
        Ingredient(name: 'Đường nước', quantity: 20, unit: 'ml'),
        Ingredient(name: 'Đá viên', quantity: 150, unit: 'g'),
      ],
      steps: [
        'Ủ trà đen cùng sả đập dập trong 150ml nước sôi khoảng 5 phút rồi lọc bỏ xác.',
        'Thêm nước cốt đào và đường nước vào, khuấy đều.',
        'Cho đào ngâm và lát cam tươi vào ly cùng đá viên.',
        'Đổ hỗn hợp trà vào ly, trang trí thêm cam và đào lên trên.',
      ],
      note: 'Nên ủ trà lạnh trước để giữ vị thanh, không bị chát.',
      createdAt: now.subtract(const Duration(days: 3)),
    ),
    Recipe(
      id: _uuid.v4(),
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
      steps: [
        'Rây bột matcha cho mịn, hòa với 30ml nước ấm và đánh tan không vón cục.',
        'Cho đường nước vào ly, thêm đá viên rồi đến sữa tươi.',
        'Rót hỗn hợp matcha lên trên cùng, khuấy nhẹ trước khi dùng.',
      ],
      note: 'Nên dùng matcha nguyên chất để tránh vị đắng gắt và lên màu đẹp.',
      createdAt: now.subtract(const Duration(days: 2)),
    ),
    Recipe(
      id: _uuid.v4(),
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
      steps: [
        'Cho bột cacao, sữa tươi, kem béo và đá viên vào máy xay sinh tố.',
        'Xay nhuyễn đến khi hỗn hợp mịn và sánh.',
        'Đổ ra ly, bơm kem tươi lên trên và rắc thêm chút bột cacao.',
      ],
      note: 'Tạm ngưng bán do đang điều chỉnh lại công thức kem béo.',
      createdAt: now.subtract(const Duration(days: 1)),
    ),
  ];

  for (final recipe in samples) {
    await box.put(recipe.id, recipe);
  }
}
