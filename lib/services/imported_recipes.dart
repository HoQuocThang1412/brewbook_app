import 'package:hive/hive.dart';

import '../models/ingredient.dart';
import '../models/recipe.dart';

const _excelRecipesSeedVersion = 'excel_recipes_seeded_v5';

String get excelRecipesSeedVersion => _excelRecipesSeedVersion;

const String _rawImportedRecipes = r'''
Nguyên liệu nền|Kem tươi|Kem béo=200 ml; Sữa tươi không đường=80 ml; Sữa đặc=40 ml|Cho kem béo, sữa tươi và sữa đặc vào ca sạch.; Đánh hoặc khuấy lạnh đến khi hỗn hợp mịn, hơi sánh.; Bảo quản lạnh và dùng trong ngày.
Nguyên liệu nền|Kem muối|Kem béo=200 ml; Sữa tươi không đường=70 ml; Sữa đặc=40 ml; Muối=1-2 g|Cho toàn bộ nguyên liệu vào ca lạnh.; Đánh đến khi kem sánh mịn, có vị mặn nhẹ.; Bảo quản lạnh, khuấy lại trước khi dùng.
Nguyên liệu nền|Nước đường|Đường cát=1000 g; Nước lọc=700 ml|Đun hoặc khuấy nước nóng với đường đến khi tan hoàn toàn.; Để nguội, lọc nếu cần.; Cho vào chai sạch và bảo quản nơi mát.
Nguyên liệu nền|Trà lài|Trà lài=20 g; Nước sôi=1000 ml; Đá=500 g|Ủ trà lài với nước sôi theo thời gian chuẩn của quán.; Lọc bỏ xác trà.; Làm lạnh nhanh bằng đá để giữ hương trà.
Nguyên liệu nền|Trà oolong|Trà oolong=20 g; Nước sôi=1000 ml; Đá=500 g|Ủ trà oolong với nước sôi theo thời gian chuẩn của quán.; Lọc bỏ xác trà.; Làm lạnh nhanh và bảo quản trong ca sạch.
Cà phê|Cà phê phin đen nóng|Bột cà phê=25 gr; Đường=1 gói; Nước sôi=80 ml (20 ml nước ủ, 60ml nước chế cf)
Cà phê|Cà phê phin sữa nóng|Bột cà phê=25 gr; Sữa đặc=20 ml; Nước sôi=80 ml (20 ml nước ủ, 60ml nước chế cf)
Cà phê|Cà phê đen đá phin|Phin pha sẵn=40 ml; Đường vàng=4g
Cà phê|Cà phê sữa đá phin|Phin pha sẵn=40 ml; Sữa đặc=20 ml
Cà phê|Cà phê muối|Phin pha sẵn=35 ml; Sữa tươi=20 ml; Sữa đặc=20 ml; Kem muối=2-4 muỗng
Cà phê|Cà phê đen ép nóng|Cafe ép=45 ml; Đường vàng=4 gr
Cà phê|Cà phê sữa ép nóng|Cafe ép=45 ml; Sữa đặc=20ml
Cà phê|Cà phê đen đá ép|Cafe ép=45 ml; Đường vàng=4 gr (khuấy tan)
Cà phê|Cà phê sữa đá ép|Cafe ép=45 ml; Sữa đặc=20ml
Cà phê|Bạc xỉu|Cafe phin=30 ml; Sữa tươi=50 ml; Sữa đặc=30 ml
Cà phê|Latte đá|Cafe ép=30 ml; Sữa tươi=90 ml; Kem béo=20 ml; Đường=10 ml
Cà phê|Capuchino đá|Cafe ép=30 ml; Sữa tươi=70 ml; Kem béo=20 ml; Đường=10 ml
Cà phê|Latte nóng|Cafe ép=30 ml; Sữa tươi=150 ml; Kem béo=20 ml; Đường riêng=10 ml
Cà phê|Capuchino nóng|Cafe ép=30 ml; Sữa tươi=1500 ml; Kem béo=20 ml; Đường riêng=10 ml
Cà phê|Cà phê yến mạch|Sữa yến mạch=100 ml; Sữa đặc=30 ml; Kem béo=10 ml; Cafe ép=30 ml; Thạch sương sáo=2 muỗng
Cà phê|Cacao đá|Sữa tươi=50ml; Sữa đặc=30ml; Cacao=Nữa muỗng
Cà phê|Cacao nóng|Sữa tươi=150ml; Sữa đặc=30ml; Nước sôi=30ml; Cacao=Nữa muỗng
Cà phê|Matcha latte yến mạch|Sữa yến mạch=120ml; Sữa đặc=30ml; Sữa yến mạch đánh matcha=40ml; Matcha=4g
Cà phê|Phindi hạnh nhân|Syrup hạnh nhân=10ml; Sữa tươi=50ml; Rich=10 ml; Đường nước=10ml; Cafe phin=15ml; Thạch cafe=2 muỗng
Trà Thanh nhiệt|Chanh sả gừng hạt chia|Nước cốt=160 ml; Cốt chanh=10 ml; Hạt chia=2 muỗng
Trà Thanh nhiệt|Trà atiso đỏ hạt chia|Nước cốt=160 ml; Cốt chanh=10 ml; Hạt chia=2 muỗng
Trà Thanh nhiệt|Trà hoa đậu biếc hạt chia|Nước cốt=160 ml; Cốt chanh=10 ml; Hạt chia=2 muỗng; Việt quốc=30 ml
Trà Thanh nhiệt|Trà đào hạt chia|Nước cốt=160 ml; Hạt chia=2 muỗng
Trà Thanh nhiệt|Trà đào cam sả|Nước cốt=120 ml; Cốt chanh=10 ml; Nước cam=10 ml; Monin sả=15 ml
Trà Thanh nhiệt|Trà thảo mộc hạt chia|Nước cốt=160 ml; Củ nắng=2 củ; Hạt chia=2 muỗng; Thạch sương sáo=2 muỗng
Trà Thanh nhiệt|Sữa tươi hoa đậu biếc|Nước cốt=60 ml; Sữa tươi=50 ml; Đường=10 ml; Rich=20 ml; Hạt chia=2 muỗng; Củ năng=2 củ; Thạch sương sáo=1 muỗng
Trà Thanh nhiệt|Trà sữa oolong|Nước cốt=160 ml; Thạch cà phê=2 muỗng; Trân châu trắng=2 muỗng
Trà Thanh nhiệt|Chanh muối mật ong|Mứt chanh muối=40 ml; Nước lọc=80 ml; Chanh=10 ml; Mật ong=15 ml
Trà Thanh nhiệt|Matcha mãng cầu|Hỗn hợp matcha=40 ml; Mứt mãng cầu=40 ml; Đường=30 ml; Nước lọc=50 ml; Muối=0.1 g
Trà Thanh nhiệt|Trà vải hoa hồng|Trà lài=100 ml; Syrup vải=40 ml; Nước đường=20 ml; Cốt chanh=10 ml
Trà Thanh nhiệt|Trà dưa lưới|Trà lài=100 ml; Mứt dưa lưới=30 ml; Syrup dưa lưới=10 ml; Nước đường=10 ml; Cốt chanh=10 ml
Trà Thanh nhiệt|Trà táo xanh|Trà lài=30 ml; Syrup táo=20 ml; Nước đường=10 ml; Mứt táo=20 ml; Nước lọc=40 ml
Trà Thanh nhiệt|Trà dâu tằm|Trà lài=100ml; Mứt dâu tằm=30ml; Sinh tố dâu tằm=20ml; Đường nước=15ml; Tắc=5ml
Trà Thanh nhiệt|Trà lài đác thơm|Trà lài=100ml; Chanh=10ml; Nước đường=30ml; Đác Thơm=2 muỗng
Trà Thanh nhiệt|Trà mãng cầu hạt đác|Trà lài=100ml; Chanh=10ml; Nước đường=30ml; Mứt mãng cầu=30ml; Hạt đác=10 cục
Trà Thanh nhiệt|Trà mận|Trà lài=120ml; Chanh=10ml; Nước đường=15ml; Mứt mận=50ml
Trà Thanh nhiệt|Trà thạch đào|Trà cozy đào=1 gói => 130ml; Nước đường=40ml; Rich=40ml; Đào miếng=2 lát; Thạch đào=3-4 lát
Trà Thanh nhiệt|Trà sen vàng|Trà olong cầu tre=2 gói; Nước sôi=130ml; Nước đường=40ml; Hạt sen=10 hạt; Kem muối=2 muỗng
Trà Thanh nhiệt|Nước chanh|Cốt chanh=40ml; Nước đường=40ml; Nước lọc=80ml; Muối=1g
Trà Thanh nhiệt|Trà gừng|Trà=1 gói; Nước sôi=180ml; Mật ong=15ml; Gừng=4-5 lát băm nhỏ
Đá xay & sinh tố|Sinh tố bơ|Bơ=200g; Sữa tươi=50ml; Sữa đặc=30ml; Nước đường=20ml; Đá=150g
Đá xay & sinh tố|Sinh tố xoài|Xoài=100g; Sữa tươi=40 ml; Nước đường=20 ml; Sữa đặc=20 ml; Sirup chanh dây=20ml; Nước lọc=40ml; Đá=150g
Đá xay & sinh tố|Sinh tố dừa|Cơm dừa=80g; Sữa đặc=30ml; Đường nước=20ml; Sữa tươi=30ml; Nước dừa=100ml; Đá=150g
Đá xay & sinh tố|Bơ già dừa non|Phần cốt dừa=cốt dừa 60ml, sữa tươi 20ml, sữa đặc 20ml, nước đường 5ml; Phần bơ=bơ 80g, nước lọc 60ml, sữa đặc 30ml, nước đường 5ml
Đá xay & sinh tố|Matcha đá xay|Bột matcha=8g; Nước đường=10ml; Sữa đặc=40ml; Sữa tươi=60ml; Bột frap=14g; Richs=20ml; Đá=150g
Đá xay & sinh tố|Cacao đá xay|Cacao=8g; Nước đường=10ml; Sữa đặc=40ml; Sữa tươi=60ml; Bột frap=14g; Richs=10ml; Đá=150g
Đá xay & sinh tố|Mãng cầu tuyết|Sữa chua=nữa hủ; Sữa đặc=30ml; Sữa tươi=50ml; Bột frap=1 muỗng; Tắc=2 trái; Mứt mãng cầu=50ml
Đá xay & sinh tố|Việt quốc đá xay|Sữa chua=nữa hủ; Sữa đặc=30ml; Sữa tươi=50ml; Bột frap=1 muỗng; Tắc=2 trái; Mứt việt quốc=50ml
Đá xay & sinh tố|Dâu tằm đá xay|Sữa chua=nữa hủ; Sữa đặc=30ml; Sữa tươi=50ml; Bột frap=1 muỗng; Tắc=2 trái; Mứt dâu tằm=50ml
Đá xay & sinh tố|Dâu tây đá xay|Sữa chua=nữa hủ; Sữa đặc=30ml; Sữa tươi=50ml; Bột frap=1 muỗng; Tắc=2 trái; Mứt dâu tây=50ml
Đá xay & sinh tố|Sữa chua hạt đác|Sữa chua=1 hủ; Sữa tươi=20ml; Sữa đặc=30ml; Tắc=2 trái; Đác thơm=2 muỗng
Đá xay & sinh tố|Sữa chua dâu tằm|Sữa chua=1 hủ; Sữa tươi=20ml; Sữa đặc=30ml; Tắc=2 trái; Mứt dâu tằm=40ml
Đá xay & sinh tố|Sữa chua việt quốc|Sữa chua=1 hủ; Sữa tươi=20ml; Sữa đặc=30ml; Tắc=2 trái; Mứt việt quốc=40ml
Đá xay & sinh tố|Sữa chua dâu tây|Sữa chua=1 hủ; Sữa tươi=20ml; Sữa đặc=30ml; Tắc=2 trái; Mứt dâu tây=40ml
Đá xay & sinh tố|Sữa chua mãng cầu|Sữa chua=1 hủ; Sữa tươi=20ml; Sữa đặc=30ml; Tắc=2 trái; Mứt mãng cầu=40ml
''';

Future<int> replaceImportedRecipes(Box<Recipe> box) async {
  await box.clear();
  await seedImportedRecipes(box);
  return _importedRecipeCount;
}

Future<void> seedImportedRecipes(Box<Recipe> box) async {
  final recipes = _buildImportedRecipes();

  for (final recipe in recipes) {
    await box.put(recipe.id, recipe);
  }
}

int get _importedRecipeCount => _rawImportedRecipes
    .split('\n')
    .map((line) => line.trim())
    .where((line) => line.isNotEmpty)
    .length;

List<Recipe> _buildImportedRecipes() {
  final now = DateTime.now();
  final lines = _rawImportedRecipes
      .split('\n')
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .toList();

  return List.generate(lines.length, (i) {
    final parts = lines[i].split('|');
    final category = parts.isNotEmpty ? parts[0].trim() : 'Khác';
    final name = parts.length > 1 ? parts[1].trim() : 'Công thức ${i + 1}';
    final ingredientsRaw = parts.length > 2 ? parts[2].trim() : '';
    final stepsRaw = parts.length > 3 ? parts.sublist(3).join('|') : '';

    return Recipe(
      id: 'excel-recipe-${i + 1}',
      name: name,
      category: category,
      cup: category == 'Nguyên liệu nền' ? 'Công thức nền' : 'Ly tiêu chuẩn',
      status: RecipeStatus.dangBan,
      ingredients: _parseIngredients(ingredientsRaw),
      steps: _parseSteps(stepsRaw),
      note: '',
      createdAt: now,
      updatedAt: now,
    );
  });
}

List<String> _parseSteps(String raw) {
  return raw
      .split(';')
      .map((step) => step.trim())
      .where((step) => step.isNotEmpty)
      .toList();
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
