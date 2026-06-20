import 'package:hive/hive.dart';

class WorkProcessItem extends HiveObject {
  String id;
  int order;

  /// Ca làm: Ca 1, Ca 2, Ca 3
  String shift;

  /// Giai đoạn: Đầu ca, Giữa ca, Cuối ca, Định kỳ
  String phase;

  /// Khu vực / nhóm việc
  String area;

  /// Nội dung công việc
  String task;

  /// Người phụ trách hướng dẫn nhân viên mới
  String assignee;

  /// Nhân viên mới đã được hướng dẫn công việc này chưa
  bool isGuided;

  /// Ghi chú thêm
  String note;

  /// Có phải công việc định kỳ không
  bool isPeriodic;

  /// Lịch định kỳ, ví dụ: Tối Thứ 3 hằng tuần
  String schedule;

  DateTime createdAt;
  DateTime updatedAt;

  WorkProcessItem({
    required this.id,
    required this.order,
    required this.shift,
    required this.phase,
    required this.area,
    required this.task,
    this.assignee = '',
    this.isGuided = false,
    this.note = '',
    this.isPeriodic = false,
    this.schedule = '',
    required this.createdAt,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? createdAt;

  WorkProcessItem copyWith({
    int? order,
    String? shift,
    String? phase,
    String? area,
    String? task,
    String? assignee,
    bool? isGuided,
    String? note,
    bool? isPeriodic,
    String? schedule,
    DateTime? updatedAt,
  }) {
    return WorkProcessItem(
      id: id,
      order: order ?? this.order,
      shift: shift ?? this.shift,
      phase: phase ?? this.phase,
      area: area ?? this.area,
      task: task ?? this.task,
      assignee: assignee ?? this.assignee,
      isGuided: isGuided ?? this.isGuided,
      note: note ?? this.note,
      isPeriodic: isPeriodic ?? this.isPeriodic,
      schedule: schedule ?? this.schedule,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class WorkProcessItemAdapter extends TypeAdapter<WorkProcessItem> {
  @override
  final int typeId = 4;

  @override
  WorkProcessItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();

    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return WorkProcessItem(
      id: fields[0] as String,
      order: fields[1] as int,
      shift: fields[2] as String,
      phase: fields[3] as String,
      area: fields[4] as String,
      task: fields[5] as String,
      assignee: fields[6] as String,
      isGuided: fields[7] as bool,
      note: fields[8] as String,
      isPeriodic: fields[9] as bool,
      schedule: fields[10] as String,
      createdAt: fields[11] as DateTime,
      updatedAt: fields[12] != null ? fields[12] as DateTime : fields[11] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, WorkProcessItem obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.order)
      ..writeByte(2)
      ..write(obj.shift)
      ..writeByte(3)
      ..write(obj.phase)
      ..writeByte(4)
      ..write(obj.area)
      ..writeByte(5)
      ..write(obj.task)
      ..writeByte(6)
      ..write(obj.assignee)
      ..writeByte(7)
      ..write(obj.isGuided)
      ..writeByte(8)
      ..write(obj.note)
      ..writeByte(9)
      ..write(obj.isPeriodic)
      ..writeByte(10)
      ..write(obj.schedule)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.updatedAt);
  }
}