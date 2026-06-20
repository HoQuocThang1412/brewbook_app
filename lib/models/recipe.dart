import 'package:hive/hive.dart';
import 'ingredient.dart';

/// Các trạng thái món nước.
class RecipeStatus {
  static const String dangBan = 'Đang bán';
  static const String ngungBan = 'Ngưng bán';

  static const List<String> all = [dangBan, ngungBan];
}

/// Model công thức pha chế món nước.
class Recipe extends HiveObject {
  String id;
  String name;
  String category; // Nhóm món, ví dụ: Cà phê, Trà sữa, Đá xay...
  String cup; // Ly sử dụng
  String status; // 'Đang bán' | 'Ngưng bán'
  List<Ingredient> ingredients;
  List<String> steps;
  String note;
  DateTime createdAt;
  DateTime updatedAt;

  Recipe({
    required this.id,
    required this.name,
    required this.category,
    required this.cup,
    required this.status,
    required this.ingredients,
    required this.steps,
    this.note = '',
    required this.createdAt,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? createdAt;

  bool get dangBan => status == RecipeStatus.dangBan;
}

/// TypeAdapter viết tay cho Recipe (typeId = 0).
class RecipeAdapter extends TypeAdapter<Recipe> {
  @override
  final int typeId = 0;

  @override
  Recipe read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Recipe(
      id: fields[0] as String,
      name: fields[1] as String,
      category: fields[2] as String,
      cup: fields[3] as String,
      status: fields[4] as String,
      ingredients: (fields[5] as List).cast<Ingredient>(),
      steps: (fields[6] as List).cast<String>(),
      note: fields[7] as String,
      createdAt: fields[8] as DateTime,
      updatedAt: fields[9] != null ? fields[9] as DateTime : (fields[8] as DateTime),
    );
  }

  @override
  void write(BinaryWriter writer, Recipe obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.cup)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.ingredients)
      ..writeByte(6)
      ..write(obj.steps)
      ..writeByte(7)
      ..write(obj.note)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt);
  }
}
