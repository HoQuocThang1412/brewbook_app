import 'package:hive/hive.dart';

class ReportChecklistItem extends HiveObject {
  String id;
  int order;
  String shift;
  String timePoint;
  String area;
  String title;
  String requirement;
  bool isDone;
  String note;
  DateTime? completedAt;

  ReportChecklistItem({
    required this.id,
    required this.order,
    required this.shift,
    required this.timePoint,
    required this.area,
    required this.title,
    required this.requirement,
    this.isDone = false,
    this.note = '',
    this.completedAt,
  });

  ReportChecklistItem copyWith({
    String? id,
    int? order,
    String? shift,
    String? timePoint,
    String? area,
    String? title,
    String? requirement,
    bool? isDone,
    String? note,
    DateTime? completedAt,
    bool clearCompletedAt = false,
  }) {
    return ReportChecklistItem(
      id: id ?? this.id,
      order: order ?? this.order,
      shift: shift ?? this.shift,
      timePoint: timePoint ?? this.timePoint,
      area: area ?? this.area,
      title: title ?? this.title,
      requirement: requirement ?? this.requirement,
      isDone: isDone ?? this.isDone,
      note: note ?? this.note,
      completedAt: clearCompletedAt ? null : (completedAt ?? this.completedAt),
    );
  }
}

class ReportChecklistSession extends HiveObject {
  String id;
  String shift;
  DateTime workingDate;
  String employeeName;
  List<ReportChecklistItem> items;
  DateTime createdAt;
  DateTime updatedAt;

  ReportChecklistSession({
    required this.id,
    required this.shift,
    required this.workingDate,
    required this.employeeName,
    required this.items,
    required this.createdAt,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? createdAt;

  int get totalItems => items.length;

  int get completedItems => items.where((item) => item.isDone).length;

  double get progress {
    if (totalItems == 0) return 0;
    return completedItems / totalItems;
  }

  bool get isCompleted => totalItems > 0 && completedItems == totalItems;
}

class ReportChecklistItemAdapter extends TypeAdapter<ReportChecklistItem> {
  @override
  final int typeId = 2;

  @override
  ReportChecklistItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return ReportChecklistItem(
      id: fields[0] as String,
      order: fields[1] as int,
      shift: fields[2] as String,
      timePoint: fields[3] as String,
      area: fields[4] as String,
      title: fields[5] as String,
      requirement: fields[6] as String,
      isDone: fields[7] as bool,
      note: fields[8] as String,
      completedAt: fields[9] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ReportChecklistItem obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.order)
      ..writeByte(2)
      ..write(obj.shift)
      ..writeByte(3)
      ..write(obj.timePoint)
      ..writeByte(4)
      ..write(obj.area)
      ..writeByte(5)
      ..write(obj.title)
      ..writeByte(6)
      ..write(obj.requirement)
      ..writeByte(7)
      ..write(obj.isDone)
      ..writeByte(8)
      ..write(obj.note)
      ..writeByte(9)
      ..write(obj.completedAt);
  }
}

class ReportChecklistSessionAdapter extends TypeAdapter<ReportChecklistSession> {
  @override
  final int typeId = 3;

  @override
  ReportChecklistSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return ReportChecklistSession(
      id: fields[0] as String,
      shift: fields[1] as String,
      workingDate: fields[2] as DateTime,
      employeeName: fields[3] as String,
      items: (fields[4] as List).cast<ReportChecklistItem>(),
      createdAt: fields[5] as DateTime,
      updatedAt: fields[6] != null ? fields[6] as DateTime : fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ReportChecklistSession obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.shift)
      ..writeByte(2)
      ..write(obj.workingDate)
      ..writeByte(3)
      ..write(obj.employeeName)
      ..writeByte(4)
      ..write(obj.items)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt);
  }
}