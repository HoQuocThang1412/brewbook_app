import '../models/work_process.dart';

class WorkProcessTemplateItem {
  final int order;
  final String shift;
  final String phase;
  final String area;
  final String task;
  final bool isPeriodic;
  final String schedule;

  const WorkProcessTemplateItem({
    required this.order,
    required this.shift,
    required this.phase,
    required this.area,
    required this.task,
    this.isPeriodic = false,
    this.schedule = '',
  });
}

const List<WorkProcessTemplateItem> defaultWorkProcessTemplates = [
  // =========================
  // CA 3 - ĐẦU CA
  // =========================
  WorkProcessTemplateItem(
    order: 1,
    shift: 'Ca 3',
    phase: 'Đầu ca',
    area: 'Mở line đèn',
    task: 'Khu vực ngoài: bật theo thứ tự T-V-T-V (T = đèn Trắng, V = đèn Vàng)',
  ),
  WorkProcessTemplateItem(
    order: 2,
    shift: 'Ca 3',
    phase: 'Đầu ca',
    area: 'Mở line đèn',
    task: 'Khu vực trong: bật theo thứ tự V-T-V-T-V (V = đèn Vàng, T = đèn Trắng)',
  ),
  WorkProcessTemplateItem(
    order: 3,
    shift: 'Ca 3',
    phase: 'Đầu ca',
    area: 'Mở line đèn',
    task: 'Mở đèn tủ quầy pha chế và tủ cà phê',
  ),
  WorkProcessTemplateItem(
    order: 4,
    shift: 'Ca 3',
    phase: 'Đầu ca',
    area: 'Khu vực khách',
    task: 'Lau chùi bàn ghế',
  ),
  WorkProcessTemplateItem(
    order: 5,
    shift: 'Ca 3',
    phase: 'Đầu ca',
    area: 'Thu ngân / Sổ sách',
    task: 'Kiểm tra két, đối chiếu ca trước bàn giao đủ 1 triệu đồng',
  ),
  WorkProcessTemplateItem(
    order: 6,
    shift: 'Ca 3',
    phase: 'Đầu ca',
    area: 'Kho / Nguyên liệu',
    task: 'Kiểm tra nguyên liệu, nước cốt ca trước bàn giao ở tủ lạnh và quầy pha chế',
  ),

  // =========================
  // CA 3 - GIỮA CA
  // =========================
  WorkProcessTemplateItem(
    order: 7,
    shift: 'Ca 3',
    phase: 'Giữa ca',
    area: 'Quầy pha chế',
    task: 'Hướng dẫn pha chế',
  ),
  WorkProcessTemplateItem(
    order: 8,
    shift: 'Ca 3',
    phase: 'Giữa ca',
    area: 'Khu vực khách',
    task: 'Chào khách ra vào quán',
  ),
  WorkProcessTemplateItem(
    order: 9,
    shift: 'Ca 3',
    phase: 'Giữa ca',
    area: 'Thu ngân / Sổ sách',
    task: 'Hướng dẫn sử dụng máy order nước',
  ),

  // =========================
  // CA 3 - CUỐI CA
  // =========================
  WorkProcessTemplateItem(
    order: 10,
    shift: 'Ca 3',
    phase: 'Cuối ca',
    area: 'Thu ngân / Sổ sách',
    task: 'Kiểm tra két và kết ca',
  ),
  WorkProcessTemplateItem(
    order: 11,
    shift: 'Ca 3',
    phase: 'Cuối ca',
    area: 'Thu ngân / Sổ sách',
    task: 'Chụp báo cáo các khu vực, chi phí và doanh số',
  ),
  WorkProcessTemplateItem(
    order: 12,
    shift: 'Ca 3',
    phase: 'Cuối ca',
    area: 'Kho / Nguyên liệu',
    task: 'Kiểm tra nguyên liệu và bàn giao cho ca sáng đi chợ',
  ),

  WorkProcessTemplateItem(
    order: 13,
    shift: 'Ca 3',
    phase: 'Cuối ca',
    area: 'Vệ sinh quầy pha chế',
    task: 'Vệ sinh khu vực trà',
  ),
  WorkProcessTemplateItem(
    order: 14,
    shift: 'Ca 3',
    phase: 'Cuối ca',
    area: 'Vệ sinh quầy pha chế',
    task: 'Vệ sinh khu vực máy xay cà phê',
  ),
  WorkProcessTemplateItem(
    order: 15,
    shift: 'Ca 3',
    phase: 'Cuối ca',
    area: 'Vệ sinh quầy pha chế',
    task: 'Vệ sinh khu vực máy ép cà phê',
  ),
  WorkProcessTemplateItem(
    order: 16,
    shift: 'Ca 3',
    phase: 'Cuối ca',
    area: 'Vệ sinh quầy pha chế',
    task: 'Vệ sinh khu vực syrup, đường và sữa',
  ),
  WorkProcessTemplateItem(
    order: 17,
    shift: 'Ca 3',
    phase: 'Cuối ca',
    area: 'Vệ sinh quầy pha chế',
    task: 'Vệ sinh khu vực tủ đá',
  ),
  WorkProcessTemplateItem(
    order: 18,
    shift: 'Ca 3',
    phase: 'Cuối ca',
    area: 'Vệ sinh quầy pha chế',
    task: 'Vệ sinh khu vực máy xay sinh tố, máy ép trái cây và shaker',
  ),
  WorkProcessTemplateItem(
    order: 19,
    shift: 'Ca 3',
    phase: 'Cuối ca',
    area: 'Vệ sinh quầy pha chế',
    task: 'Vệ sinh khu vực dao kéo',
  ),
  WorkProcessTemplateItem(
    order: 20,
    shift: 'Ca 3',
    phase: 'Cuối ca',
    area: 'Vệ sinh quầy pha chế',
    task: 'Vệ sinh khu vực ly và lavabo rửa ly',
  ),
  WorkProcessTemplateItem(
    order: 21,
    shift: 'Ca 3',
    phase: 'Cuối ca',
    area: 'Vệ sinh quầy pha chế',
    task: 'Vệ sinh khu vực tủ lạnh',
  ),

  WorkProcessTemplateItem(
    order: 22,
    shift: 'Ca 3',
    phase: 'Cuối ca',
    area: 'Vệ sinh khu vực ngoài',
    task: 'Quét nhà trong và ngoài',
  ),
  WorkProcessTemplateItem(
    order: 23,
    shift: 'Ca 3',
    phase: 'Cuối ca',
    area: 'Vệ sinh khu vực ngoài',
    task: 'Lau nhà từ trong ra ngoài',
  ),
  WorkProcessTemplateItem(
    order: 24,
    shift: 'Ca 3',
    phase: 'Cuối ca',
    area: 'Vệ sinh khu vực ngoài',
    task: 'Lau bàn ghế và chỉnh xếp lại bàn ghế',
  ),

  WorkProcessTemplateItem(
    order: 25,
    shift: 'Ca 3',
    phase: 'Cuối ca',
    area: 'Nhà vệ sinh',
    task: 'Vệ sinh bồn cầu',
  ),
  WorkProcessTemplateItem(
    order: 26,
    shift: 'Ca 3',
    phase: 'Cuối ca',
    area: 'Nhà vệ sinh',
    task: 'Chùi rửa sàn nhà vệ sinh',
  ),
  WorkProcessTemplateItem(
    order: 27,
    shift: 'Ca 3',
    phase: 'Cuối ca',
    area: 'Nhà vệ sinh',
    task: 'Vệ sinh lavabo',
  ),
  WorkProcessTemplateItem(
    order: 28,
    shift: 'Ca 3',
    phase: 'Cuối ca',
    area: 'Nhà vệ sinh',
    task: 'Vứt túi rác và thay túi rác mới',
  ),

  WorkProcessTemplateItem(
    order: 29,
    shift: 'Ca 3',
    phase: 'Cuối ca',
    area: 'Tắt điện và khoá cửa',
    task: 'Tắt điện nhà vệ sinh',
  ),
  WorkProcessTemplateItem(
    order: 30,
    shift: 'Ca 3',
    phase: 'Cuối ca',
    area: 'Tắt điện và khoá cửa',
    task: 'Tắt 4 quạt gió',
  ),
  WorkProcessTemplateItem(
    order: 31,
    shift: 'Ca 3',
    phase: 'Cuối ca',
    area: 'Tắt điện và khoá cửa',
    task: 'Tắt máy lạnh',
  ),
  WorkProcessTemplateItem(
    order: 32,
    shift: 'Ca 3',
    phase: 'Cuối ca',
    area: 'Tắt điện và khoá cửa',
    task: 'Tắt điện tủ trưng bày cà phê',
  ),
  WorkProcessTemplateItem(
    order: 33,
    shift: 'Ca 3',
    phase: 'Cuối ca',
    area: 'Tắt điện và khoá cửa',
    task: 'Tắt tivi',
  ),
  WorkProcessTemplateItem(
    order: 34,
    shift: 'Ca 3',
    phase: 'Cuối ca',
    area: 'Tắt điện và khoá cửa',
    task: 'Tắt line đèn trong và ngoài',
  ),
  WorkProcessTemplateItem(
    order: 35,
    shift: 'Ca 3',
    phase: 'Cuối ca',
    area: 'Tắt điện và khoá cửa',
    task: 'Cất bảng giảm giá',
  ),
  WorkProcessTemplateItem(
    order: 36,
    shift: 'Ca 3',
    phase: 'Cuối ca',
    area: 'Tắt điện và khoá cửa',
    task: 'Đóng cửa',
  ),

  // =========================
  // CA 3 - ĐỊNH KỲ
  // =========================
  WorkProcessTemplateItem(
    order: 37,
    shift: 'Ca 3',
    phase: 'Định kỳ',
    area: 'Công việc định kỳ',
    task: 'Tắt CB cửa ra vào',
    isPeriodic: true,
    schedule: 'Sáng Thứ 2 hằng tuần',
  ),
  WorkProcessTemplateItem(
    order: 38,
    shift: 'Ca 3',
    phase: 'Định kỳ',
    area: 'Công việc định kỳ',
    task: 'Hướng dẫn và kiểm tra nguyên liệu tồn kho',
    isPeriodic: true,
    schedule: 'Tối Thứ 3 hằng tuần',
  ),
  WorkProcessTemplateItem(
    order: 39,
    shift: 'Ca 3',
    phase: 'Định kỳ',
    area: 'Công việc định kỳ',
    task: 'Bật CB cửa ra vào',
    isPeriodic: true,
    schedule: 'Tối Thứ 3 hằng tuần',
  ),
  WorkProcessTemplateItem(
    order: 40,
    shift: 'Ca 3',
    phase: 'Định kỳ',
    area: 'Công việc định kỳ',
    task: 'Tẩy máy ép cà phê bằng bột vệ sinh chuyên dụng',
    isPeriodic: true,
    schedule: 'Tối Thứ 5 và Chủ nhật hằng tuần',
  ),
];

List<WorkProcessItem> buildDefaultWorkProcessItems() {
  final now = DateTime.now();

  return defaultWorkProcessTemplates.map((item) {
    return WorkProcessItem(
      id: 'work-${item.shift}-${item.order}-${now.microsecondsSinceEpoch}',
      order: item.order,
      shift: item.shift,
      phase: item.phase,
      area: item.area,
      task: item.task,
      isPeriodic: item.isPeriodic,
      schedule: item.schedule,
      createdAt: now,
    );
  }).toList();
}