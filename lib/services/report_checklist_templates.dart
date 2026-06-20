import '../models/report_checklist.dart';

class ReportChecklistTemplateItem {
  final int order;
  final String timePoint;
  final String area;
  final String title;
  final String requirement;

  const ReportChecklistTemplateItem({
    required this.order,
    required this.timePoint,
    required this.area,
    required this.title,
    required this.requirement,
  });
}

const Map<String, List<ReportChecklistTemplateItem>> reportChecklistTemplates = {
  'Ca 1': [
    ReportChecklistTemplateItem(order: 1, timePoint: 'Đầu ca', area: 'Khu vực ngoài', title: 'Chụp báo cáo vỉa hè', requirement: 'Yêu cầu: Vỉa hè sạch sẽ, không có rác'),
    ReportChecklistTemplateItem(order: 2, timePoint: 'Đầu ca', area: 'Khu vực ngoài', title: 'Kệ sách, mặt quầy chỗ cây lựu', requirement: 'Yêu cầu: Sắp xếp gọn gàng, lau sạch bụi'),
    ReportChecklistTemplateItem(order: 3, timePoint: 'Đầu ca', area: 'Khu vực ngoài', title: 'Ti vi', requirement: 'Yêu cầu: Kiểm tra âm lượng vừa đủ nghe, phù hợp không gian'),
    ReportChecklistTemplateItem(order: 4, timePoint: 'Đầu ca', area: 'Khu vực ngoài', title: 'Đèn trần ngoài và trong phòng lạnh', requirement: 'Yêu cầu: Kiểm tra hệ thống đèn hoạt động tốt'),
    ReportChecklistTemplateItem(order: 5, timePoint: 'Đầu ca', area: 'Khu vực ngoài', title: 'Máy lạnh', requirement: 'Yêu cầu: Chụp rõ nhiệt độ hiển thị trên remote'),
    ReportChecklistTemplateItem(order: 6, timePoint: 'Đầu ca', area: 'Khu vực ngoài', title: 'Bàn ghế trong và ngoài', requirement: 'Yêu cầu: Sắp xếp gọn gàng, đã được lau sạch bụi'),
    ReportChecklistTemplateItem(order: 7, timePoint: 'Đầu ca', area: 'Khu vực trong quầy', title: 'Test cà phê - Cân gram đúng 18g', requirement: 'Yêu cầu: Cân đúng định lượng gram cà phê quy định'),
    ReportChecklistTemplateItem(order: 8, timePoint: 'Đầu ca', area: 'Khu vực trong quầy', title: 'Test cà phê - Thời gian chảy 28-30s', requirement: 'Yêu cầu: Quay video ngắn test thời gian chiết xuất'),
    ReportChecklistTemplateItem(order: 9, timePoint: 'Cuối ca', area: 'Khu vực trong quầy', title: 'Khu vực quầy trà', requirement: 'Yêu cầu: Dọn dẹp, lau sạch mặt quầy'),
    ReportChecklistTemplateItem(order: 10, timePoint: 'Cuối ca', area: 'Khu vực trong quầy', title: 'Khu vực máy xay cà phê', requirement: 'Yêu cầu: Vệ sinh hộc chứa, quét sạch bột cà phê vương vãi'),
    ReportChecklistTemplateItem(order: 11, timePoint: 'Cuối ca', area: 'Khu vực trong quầy', title: 'Khu vực máy ép cà phê', requirement: 'Yêu cầu: Vệ sinh máy, xếp gọn ly lên trên máy ép'),
    ReportChecklistTemplateItem(order: 12, timePoint: 'Cuối ca', area: 'Khu vực trong quầy', title: 'Khu vực sirup, tủ đá, đường và sữa', requirement: 'Yêu cầu: Lau sạch chai lọ, đậy kín, đóng tủ đá, sữa được fill đầy'),
    ReportChecklistTemplateItem(order: 13, timePoint: 'Cuối ca', area: 'Khu vực trong quầy', title: 'Khu vực máy xay sinh tố, máy ép trái cây, shaker', requirement: 'Yêu cầu: Rửa sạch, úp khô ráo đúng nơi quy định'),
    ReportChecklistTemplateItem(order: 14, timePoint: 'Cuối ca', area: 'Khu vực trong quầy', title: 'Khu vực kệ đựng dao kéo', requirement: 'Yêu cầu: Sắp xếp ngăn nắp, an toàn'),
    ReportChecklistTemplateItem(order: 15, timePoint: 'Cuối ca', area: 'Khu vực trong quầy', title: 'Khu vực kệ ly và bồn rửa ly', requirement: 'Yêu cầu: Bồn rửa sạch sẽ, không tồn đọng ly bẩn'),
    ReportChecklistTemplateItem(order: 16, timePoint: 'Cuối ca', area: 'Khu vực trong quầy', title: 'Tủ lạnh', requirement: 'Yêu cầu: Kiểm tra đóng kín, sắp xếp nguyên liệu bên trong'),
    ReportChecklistTemplateItem(order: 17, timePoint: 'Cuối ca', area: 'Khu vực trong quầy', title: 'Chụp báo cáo doanh số', requirement: 'Yêu cầu: Chụp màn hình POS hoặc hóa đơn tổng'),
    ReportChecklistTemplateItem(order: 18, timePoint: 'Cuối ca', area: 'Khu vực ngoài', title: 'Phơi thảm bar', requirement: 'Yêu cầu: Xịt rửa sạch và đem phơi'),
    ReportChecklistTemplateItem(order: 19, timePoint: 'Cuối ca', area: 'Khu vực ngoài', title: 'Khu vực bàn ghế trong và ngoài', requirement: 'Yêu cầu: Bàn ghế gọn gàng, sạch sẽ bàn giao ca sau'),
  ],
  'Ca 2': [
    ReportChecklistTemplateItem(order: 1, timePoint: 'Cuối ca', area: 'Khu vực trong quầy', title: 'Khu vực quầy trà', requirement: 'Yêu cầu: Dọn dẹp, lau sạch mặt quầy'),
    ReportChecklistTemplateItem(order: 2, timePoint: 'Cuối ca', area: 'Khu vực trong quầy', title: 'Khu vực máy xay cà phê', requirement: 'Yêu cầu: Vệ sinh sạch sẽ'),
    ReportChecklistTemplateItem(order: 3, timePoint: 'Cuối ca', area: 'Khu vực trong quầy', title: 'Khu vực máy ép cà phê', requirement: 'Yêu cầu: Vệ sinh máy, xếp gọn ly trên máy'),
    ReportChecklistTemplateItem(order: 4, timePoint: 'Cuối ca', area: 'Khu vực trong quầy', title: 'Khu vực sirup, tủ đá, đường và sữa', requirement: 'Yêu cầu: Sắp xếp gọn gàng, lau sạch'),
    ReportChecklistTemplateItem(order: 5, timePoint: 'Cuối ca', area: 'Khu vực trong quầy', title: 'Khu vực máy xay sinh tố, máy ép trái cây, shaker', requirement: 'Yêu cầu: Rửa sạch, úp gọn'),
    ReportChecklistTemplateItem(order: 6, timePoint: 'Cuối ca', area: 'Khu vực trong quầy', title: 'Khu vực kệ đựng dao kéo', requirement: 'Yêu cầu: Sắp xếp ngăn nắp'),
    ReportChecklistTemplateItem(order: 7, timePoint: 'Cuối ca', area: 'Khu vực trong quầy', title: 'Khu vực kệ ly và bồn rửa ly', requirement: 'Yêu cầu: Vệ sinh sạch sẽ bồn rửa'),
    ReportChecklistTemplateItem(order: 8, timePoint: 'Cuối ca', area: 'Khu vực trong quầy', title: 'Tủ lạnh', requirement: 'Yêu cầu: Kiểm tra và sắp xếp gọn'),
    ReportChecklistTemplateItem(order: 9, timePoint: 'Cuối ca', area: 'Khu vực trong quầy', title: 'Chụp báo cáo doanh số', requirement: 'Yêu cầu: Chụp báo cáo doanh thu ca 2'),
    ReportChecklistTemplateItem(order: 10, timePoint: 'Cuối ca', area: 'Khu vực trong quầy', title: 'Chụp báo cáo tủ nguyên vật liệu khô', requirement: 'Yêu cầu: Kiểm tra và sắp xếp gọn'),
    ReportChecklistTemplateItem(order: 11, timePoint: 'Cuối ca', area: 'Khu vực trong quầy', title: 'Chụp báo cáo tủ nguyên vật liệu ướt', requirement: 'Yêu cầu: Kiểm tra và sắp xếp gọn'),
    ReportChecklistTemplateItem(order: 12, timePoint: 'Cuối ca', area: 'Khu vực trong quầy', title: 'Chụp báo cáo tủ dưới quầy thu ngân', requirement: 'Yêu cầu: Kiểm tra và sắp xếp gọn'),
    ReportChecklistTemplateItem(order: 13, timePoint: 'Cuối ca', area: 'Khu vực ngoài', title: 'Khu vực bàn ghế trong và ngoài', requirement: 'Yêu cầu: Sắp xếp bàn ghế gọn gàng, lau sạch bụi'),
    ReportChecklistTemplateItem(order: 14, timePoint: 'Cuối ca', area: 'Khu vực ngoài', title: 'Chụp báo cáo tưới cây', requirement: 'Yêu cầu: Chụp hình ảnh cây xanh đã được tưới'),
    ReportChecklistTemplateItem(order: 15, timePoint: 'Cuối ca', area: 'Khu vực ngoài', title: 'Phơi thảm bar', requirement: 'Yêu cầu: Vệ sinh và phơi khô'),
  ],
  'Ca 3': [
    ReportChecklistTemplateItem(order: 1, timePoint: 'Cuối ca', area: 'Khu vực trong quầy', title: 'Khu vực quầy trà', requirement: 'Yêu cầu: Dọn dẹp, lau sạch mặt quầy cuối ngày'),
    ReportChecklistTemplateItem(order: 2, timePoint: 'Cuối ca', area: 'Khu vực trong quầy', title: 'Khu vực máy xay cà phê', requirement: 'Yêu cầu: Vệ sinh sạch sẽ bột cà phê'),
    ReportChecklistTemplateItem(order: 3, timePoint: 'Cuối ca', area: 'Khu vực trong quầy', title: 'Khu vực máy ép cà phê', requirement: 'Yêu cầu: Vệ sinh sạch sẽ, xếp gọn ly'),
    ReportChecklistTemplateItem(order: 4, timePoint: 'Cuối ca', area: 'Khu vực trong quầy', title: 'Khu vực sirup, tủ đá, đường và sữa', requirement: 'Yêu cầu: Lau chùi sạch sẽ, đậy kín'),
    ReportChecklistTemplateItem(order: 5, timePoint: 'Cuối ca', area: 'Khu vực trong quầy', title: 'Khu vực máy xay sinh tố, máy ép trái cây, shaker', requirement: 'Yêu cầu: Rửa sạch, vệ sinh kỹ chuẩn bị cho ngày mai'),
    ReportChecklistTemplateItem(order: 6, timePoint: 'Cuối ca', area: 'Khu vực trong quầy', title: 'Khu vực kệ đựng dao kéo', requirement: 'Yêu cầu: Sắp xếp gọn gàng'),
    ReportChecklistTemplateItem(order: 7, timePoint: 'Cuối ca', area: 'Khu vực trong quầy', title: 'Khu vực kệ ly và bồn rửa ly', requirement: 'Yêu cầu: Rửa hết ly, dọn sạch bồn rửa'),
    ReportChecklistTemplateItem(order: 8, timePoint: 'Cuối ca', area: 'Khu vực trong quầy', title: 'Tủ lạnh', requirement: 'Yêu cầu: Kiểm tra nhiệt độ, đóng kín tủ'),
    ReportChecklistTemplateItem(order: 9, timePoint: 'Cuối ca', area: 'Khu vực trong quầy', title: 'Phơi thảm bar, giặt khăn', requirement: 'Yêu cầu: Giặt sạch toàn bộ khăn quầy, phơi thảm'),
    ReportChecklistTemplateItem(order: 10, timePoint: 'Cuối ca', area: 'Khu vực trong quầy', title: 'Chụp check nguyên liệu', requirement: 'Yêu cầu: Chụp kiểm kê nguyên liệu tồn cuối ngày/chuẩn bị ca sáng'),
    ReportChecklistTemplateItem(order: 11, timePoint: 'Cuối ca', area: 'Khu vực trong quầy', title: 'Chụp doanh số', requirement: 'Yêu cầu: Chụp báo cáo doanh thu cuối ngày'),
    ReportChecklistTemplateItem(order: 12, timePoint: 'Cuối ca', area: 'Khu vực trong quầy', title: 'Chụp chi phí', requirement: 'Yêu cầu: Báo cáo các khoản chi trong ngày nếu có'),
    ReportChecklistTemplateItem(order: 13, timePoint: 'Cuối ca', area: 'Khu vực ngoài', title: 'Khu vực bàn ghế trong và ngoài', requirement: 'Yêu cầu: Sắp xếp gọn bàn ghế, dọn dẹp mặt bằng'),
    ReportChecklistTemplateItem(order: 14, timePoint: 'Cuối ca', area: 'Khu vực ngoài', title: 'Chụp máy lạnh, quạt, ti vi đã tắt', requirement: 'Yêu cầu: Đảm bảo tất cả thiết bị điện đã tắt hoàn toàn'),
    ReportChecklistTemplateItem(order: 15, timePoint: 'Cuối ca', area: 'Khu vực ngoài', title: 'Chụp nhà vệ sinh, gương đã vệ sinh', requirement: 'Yêu cầu: Sạch sẽ, không mùi, gương lau kính sạch'),
    ReportChecklistTemplateItem(order: 16, timePoint: 'Cuối ca', area: 'Khu vực ngoài', title: 'Chụp kệ cà phê đã được tắt điện', requirement: 'Yêu cầu: Đảm bảo tắt điện kệ trưng bày an toàn'),
  ],
};

List<ReportChecklistItem> buildReportItemsForShift(String shift) {
  final template = reportChecklistTemplates[shift] ?? reportChecklistTemplates['Ca 1']!;
  final stamp = DateTime.now().microsecondsSinceEpoch;

  return template.map((item) {
    return ReportChecklistItem(
      id: '$shift-${item.order}-$stamp',
      order: item.order,
      shift: shift,
      timePoint: item.timePoint,
      area: item.area,
      title: item.title,
      requirement: item.requirement,
    );
  }).toList();
}