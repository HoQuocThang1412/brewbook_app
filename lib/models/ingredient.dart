import 'package:hive/hive.dart';

/// Model nguyên liệu trong một công thức pha chế.
class Ingredient extends HiveObject {
  String name;
  double quantity;
  String unit;

  Ingredient({
    required this.name,
    required this.quantity,
    required this.unit,
  });

  Ingredient copyWith({String? name, double? quantity, String? unit}) {
    return Ingredient(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
    );
  }
}

/// TypeAdapter viết tay cho Ingredient (typeId = 1).
/// Viết tay để KHÔNG cần chạy build_runner, tiện cho người mới dùng Flutter.
class IngredientAdapter extends TypeAdapter<Ingredient> {
  @override
  final int typeId = 1;

  @override
  Ingredient read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ingredient(
      name: fields[0] as String,
      quantity: (fields[1] as num).toDouble(),
      unit: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Ingredient obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.quantity)
      ..writeByte(2)
      ..write(obj.unit);
  }
}
