import 'package:hive/hive.dart';

import '../models/ingredient.dart';
import '../models/recipe.dart';

const _excelRecipesSeedVersion = 'excel_recipes_seeded_v1';

String get excelRecipesSeedVersion => _excelRecipesSeedVersion;

const String _rawImportedRecipes = r'''
Cà phê|Cà phê đen nóng|Bột cà phê=25 gr; Đường=1 gói; Nước sôi=80 ml; Bột cà phê=25 gr; Sữa đặc=20 ml; Nước sôi=80 ml
Cà phê|Cà phê đen đá|Phin pha sẵn=40 ml; Đường=1-2 gói (ước lượng)
Cà phê|Cà phê đen sữa nóng|Phin pha sẵn=40 ml; Sữa đặc=20 ml
Cà phê|Cà phê muối|Phin pha sẵn=35 ml; Sữa tươi=20 ml; Sữa đặc=20 ml; Kem muối=2-4 muỗng
Cà phê|Cà phê đen ép nóng|Bột café xay=2 cup; Nước=2 cup; Đường=1 túi
Cà phê|Cà phê đen ép sữa nóng|Bột café xay=2 cup; Nước=2 cup; Sữa đặc=20 ml
Cà phê|Cà phê đen ép đá|Bột café xay=2 cup; Nước=2 cup; Đường=15 gr (ước lượng)
Cà phê|Cà phê đen sữa đá|Bột café xay=2 cup; Nước=2 cup; Sữa đặc=20 ml
Cà phê|Bạc xỉu|Bột café xay=1 cup; Nước=1 cup; Sữa tươi=50 ml; Sữa đặc=30 ml
Cà phê|Ice Latte|Bột café xay=1 cup; Nước=1 cup; Sữa tươi=90 ml; Kem béo=20 ml; Đường=10 ml
Cà phê|Capuchino|Bột café xay=1 cup; Nước=1 cup; Sữa tươi=70 ml; Kem béo=20 ml; Đường=10 ml
Cà phê|Cà phê yến mạch|Sữa yến mạch=100 ml; Sữa đặc=30 ml; Kem béo=30 ml; Café ép=1 cup; Thạch sương sáo=2 muỗng
Cà phê|Cacao đá|Sữa tươi=50ml; Sữa đặc=30ml; Cacao=Nữa muỗng
Cà phê|Cacao nóng|Sữa tươi=120ml; Sữa đặc=30ml; Nước sôi=30ml; Cacao=Nữa muỗng
Cà phê|Matcha latte yến mạch|Sữa yến mạch=120ml; Sữa đặc=30ml; Sữa yên mạch đánh matcha=40ml; Đường=10ml; Matcha=4g
Trà Thanh nhiệt|Chanh sả gừng hạt chia|Nước cốt=160 ml; Cốt chanh=10 ml; Hạt chia=2 muỗng
Trà Thanh nhiệt|Trà atiso đỏ hạt chia|Nước cốt=160 ml; Cốt chanh=10 ml; Hạt chia=2 muỗng
Trà Thanh nhiệt|Trà hoa đậu biếc hạt chia|Nước cốt=160 ml; Cốt chanh=10 ml; Hạt chia=2 muỗng; Việt quốc=30 ml
Trà Thanh nhiệt|Trà đào hạt chia|Nước cốt=160 ml; Hạt chia=2 muỗng
Trà Thanh nhiệt|Trà đào cam sả|Nước cốt=120 ml; Cốt chanh=10 ml; Nước cam=10 ml; Monin sả=15 ml
Trà Thanh nhiệt|Trà thảo mộc hạt chia|Nước cốt=160 ml; Củ nắng=2 củ; Hạt chia=2 muỗng; Thạch sương sáo=2 muỗng
Trà Thanh nhiệt|Sữa tươi hoa đậu biếc|Nước cốt=60 ml; Sữa tươi=50 ml; Đường=10 ml; Hạt chia=2 muỗng; Củ năng=2 củ
Trà Thanh nhiệt|Trà sữa oolong|Nước cốt=160 ml; Thạch cà phê=2 muỗng; Trân châu trắng=2 muỗng; Cốt chanh=10 ml
Trà Thanh nhiệt|Chanh muối mật ong|Mứt chanh muối=40 ml; Nước lọc=80 ml; Mật ong=15 ml
Trà Thanh nhiệt|Matcha mãng cầu|Hỗn hợp matcha=40 ml; Mứt mãng cầu=40 ml; Đường=30 ml; Nước lọc=50 ml; Muối=0.1 g
Trà Thanh nhiệt|Trà vải hoa hồng|Trà lài=100 ml; Syrup vải=20 ml; Nước đường=20 ml; Cốt chanh=10 ml
Trà Thanh nhiệt|Trà dưa lưới|Trà lài=100 ml; Mứt dưa lưới=30 ml; Syrup dưa lưới=30 ml; Nước đường=10 ml; Cốt chanh=10 ml
Trà Thanh nhiệt|Trà táo xanh|Trà lài=100 ml; Syrup táo=20 ml; Nước đường=20 ml; Mứt táo=20 ml; Nước lọc=40 ml
Trà Thanh nhiệt|Trà dâu tằm|Trà ôlong=100ml; Mứt dâu tằm=30ml; Sinh tố dâu tằm=20ml; Đường nước=15ml; Tắc=5ml
Trà Thanh nhiệt|Trà lài đác thơm|Trà lài=100ml; Chanh=20ml; Nước đường=40ml; Đác Thơm=2 muỗng
Trà Thanh nhiệt|Trà sen vàng|Trà olong cầu tre=2 gói; Nước sôi=130ml; Nước đường=40ml; Hạt sen=10 hạt; kem muối=2 muỗng
Trà Thanh nhiệt|Nước chanh|Cốt chanh=40ml; Nước đường=40ml; Nước lọc=80ml; muối=11g
Trà Thanh nhiệt|Trà gừng|Trà=1gói; Nước sôi=180ml; Mật ong=15ml; Gừng=4-5 lát băm nhỏ
Đá xay & sinh tố|Sinh tố bơ|bơ=200g; sữa tươi=30ml; sữa đặc=60ml; nước đường=10ml; đá=150g
Đá xay & sinh tố|Sinh tố xoài|xoài=150g; mật ong=30ml; sirup chanh dây=20ml; nước lọc=20ml; đá=180g
Đá xay & sinh tố|Sinh tố dừa|cơm dừa=80g; sữa đặc=30ml; đường nước=20ml; sữa tươi=30ml; nước lọc=60ml; đá=150g
Đá xay & sinh tố|Bơ già dừa non|Phần cốt dừa=phần bơ; cốt dừa : 60ml=bơ : 80g; sữa tươi : 20ml=sữa tươi : 60ml; sữa đặc : 20ml=sữa đặc : 30ml; nước đường : 5ml=nước đường: 5ml; Nguyên liệu=đá : 70g
Đá xay & sinh tố|Matcha đá xay|bột matcha=8g; nước đường=10ml; sữa đặc=40ml; sữa tươi=60ml; bột frap=14g; rrichs=10ml; đá=1 ly
Đá xay & sinh tố|Cacao đá xay|cacao=8g; nước đường=10ml; sữa đặc=40ml; sữa tươi=60ml; bột frap=14g; rrichs=10ml; đá=1 ly
Đá xay & sinh tố|mãng cầu tuyết|sữa chua=nữa hủ; sữa đặc=30ml; sữa tươi=50ml; bột frap=1 muỗng; tắc=2 trái; mứt=50ml
Đá xay & sinh tố|sữa chua hạt đác|sữa chua=1 hủ; sữa tươi=20ml; sữa đặc=30ml; tắc=2 trái; đác thơm=2 muỗng
Đá xay & sinh tố|sữa chua dâu tằm|sữa chua=1 hủ; sữa tươi=20ml; sữa đặc=30ml; tắc=2 trái; mứt dâu tằm=40ml
''';

Future<void> seedImportedRecipes(Box<Recipe> box) async {
  final now = DateTime.now();
  final lines = _rawImportedRecipes
      .split('\n')
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .toList();

  for (var i = 0; i < lines.length; i++) {
    final parts = lines[i].split('|');
    if (parts.length < 3) continue;

    final category = parts[0].trim();
    final name = parts[1].trim();
    final ingredientsRaw = parts.sublist(2).join('|');

    final recipe = Recipe(
      id: 'excel-recipe-${i + 1}',
      name: name,
      category: category,
      cup: 'Ly tiêu chuẩn',
      status: RecipeStatus.dangBan,
      ingredients: _parseIngredients(ingredientsRaw),
      steps: const [
        'Chuẩn bị đầy đủ nguyên liệu theo đúng định lượng.',
        'Thực hiện pha chế theo quy trình vận hành của quán.',
        'Kiểm tra hương vị, hoàn thiện ly và phục vụ khách.',
      ],
      note: 'Nhập từ file Excel Công thức.xlsx. Một số định lượng mô tả được giữ nguyên theo file gốc.',
      createdAt: now,
      updatedAt: now,
    );

    await box.put(recipe.id, recipe);
  }
}

List<Ingredient> _parseIngredients(String raw) {
  return raw
      .split(';')
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .map((item) {
        final splitIndex = item.indexOf('=');
        final name = splitIndex == -1 ? item.trim() : item.substring(0, splitIndex).trim();
        final quantityText = splitIndex == -1 ? '' : item.substring(splitIndex + 1).trim();
        final parsed = _parseQuantity(quantityText);

        return Ingredient(
          name: name.isEmpty ? 'Nguyên liệu' : name,
          quantity: parsed.quantity,
          unit: parsed.unit,
        );
      })
      .toList();
}

_ParsedQuantity _parseQuantity(String raw) {
  final text = raw.trim();
  if (text.isEmpty) return const _ParsedQuantity(0, '');

  if (RegExp(r'\d\s*[-–]\s*\d').hasMatch(text) || text.contains(':')) {
    return _ParsedQuantity(0, text);
  }

  final match = RegExp(r'^(\d+(?:[,.]\d+)?)(.*)$').firstMatch(text);
  if (match == null) return _ParsedQuantity(0, text);

  final quantity = double.tryParse(match.group(1)!.replaceAll(',', '.')) ?? 0;
  final unit = match.group(2)!.trim();

  return _ParsedQuantity(quantity, unit);
}

class _ParsedQuantity {
  final double quantity;
  final String unit;

  const _ParsedQuantity(this.quantity, this.unit);
}
