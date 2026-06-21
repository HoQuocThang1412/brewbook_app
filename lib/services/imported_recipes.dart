import 'package:hive/hive.dart';

import '../models/ingredient.dart';
import '../models/recipe.dart';

const _excelRecipesSeedVersion = 'excel_recipes_seeded_v9';

String get excelRecipesSeedVersion => _excelRecipesSeedVersion;

const String _rawImportedRecipes = r'''
Nguyên liệu nền|HẠT CHIA|Hạt chia=30 g; nước ấm hoặc sôi=500 ml|cho ca 2 vào trộn đều
Nguyên liệu nền|KEM MUỐI|richs=100 ml; Sữa tươi không đường=50 ml; Sữa đặc=10 ml; Muối=0.1 g; base=50 ml|Cho toàn bộ nguyên liệu vào ca lạnh.; Đánh đến khi kem sánh mịn, có vị mặn nhẹ.; Bảo quản lạnh, khuấy lại trước khi dùng.
Nguyên liệu nền|KEM TƯƠI|richs=120 ml; Sữa tươi không đường=60 ml; base=120 ml|Cho kem béo, sữa tươi và sữa đặc vào ca sạch.; Đánh hoặc khuấy lạnh đến khi hỗn hợp mịn, hơi sánh.; Bảo quản lạnh và dùng trong ngày.
Nguyên liệu nền|NƯỚC ĐƯỜNG|Đường cát=750 g; Nước sôi=500 ml|Đun hoặc khuấy nước nóng với đường đến khi tan hoàn toàn.; Để nguội, lọc nếu cần.; Cho vào chai sạch và bảo quản nơi mát.
Nguyên liệu nền|TRÀ LÀI|Trà lài=20 g; Nước sôi=500 ml; Đá=500 g|trán trà bằng nước sôi - Ủ trà lài với nước sôi 15p; Lọc bỏ xác trà. bằng ray và khăn lọc; Làm lạnh nhanh bằng đá để giữ hương trà.
Cà phê|CÀ PHÊ MUỐI|Phin pha sẵn=35 ml; Sữa tươi=20 ml; Sữa đặc=20 ml; Kem muối=2-4 muỗng|Cho sữa đặc và sữa tươi vào ly.; Cho cà phê phin vào và khuấy nhẹ và cho đá vào; Phủ kem muối lên trên. - rắc bột cacao phủ kem muối
Cà phê|CÀ PHÊ ĐEN ÉP NÓNG|Cafe ép=45 ml; Đường vàng=4 gr|Chiết xuất cà phê ép.; Cho đường gói vào đĩa; cho ly cafe đã được chiết xuất lên đĩa
Cà phê|CÀ PHÊ SỮA ÉP NÓNG|Cafe ép=45 ml; Sữa đặc=20 ml|Cho sữa đặc vào ly.; Chiết xuất cà phê ép nóng.; Rót cà phê lên sữa.; Khuấy đều.
Cà phê|CÀ PHÊ ĐEN ĐÁ ÉP|Cafe ép=45 ml; Đường vàng=4 gr (khuấy tan)|Chiết xuất cà phê ép.; Làm lạnh cà phê trước khi cho vào ly.; Khuấy tan đường với cà phê.; Cho đá vào ly.; Rót cà phê vào ly.
Cà phê|CÀ PHÊ SỮA ĐÁ ÉP|Cafe ép=45 ml; Sữa đặc=20 ml|Chiết xuất cà phê ép.; Làm lạnh cà phê trước khi cho vào ly.; Cho sữa đặc vào ly - cho cà phê đã làm lạnh vào khoáy đều - cho đá vào
Cà phê|BẠC XỈU|Cafe phin=30 ml; Sữa tươi=50 ml; Sữa đặc=30 ml|Cho sữa đặc và sữa tươi vào đáy ly.; Khuấy đều phần sữa.; Cho đá vào ly.; Đánh bọt cà phê.; Rót cà phê lên trên để tạo 2 tầng.
Cà phê|LATTE ĐÁ|Cafe ép=30 ml; Sữa tươi=90 ml; Kem béo=20 ml; Đường=10 ml|Cho sữa tươi, kem béo và đường vào shaker; Thêm đá và lắc đều.; Đổ hỗn hợp ra ly.; Rót cà phê ép lên trên cùng.
Cà phê|CAPUCHINO ĐÁ|Cafe ép=30 ml; Sữa tươi=70 ml; Kem béo=20 ml; Đường=10 ml|Cho sữa tươi, kem béo và đường vào shaker; Thêm đá và lắc đều.; Đổ hỗn hợp ra ly.; Rót cà phê ép lên trên cùng.
Cà phê|LATTE NÓNG|Cafe ép=30 ml; Sữa tươi=150 ml; Kem béo=20 ml; Đường riêng=10 ml|Cho sữa tươi, kem béo và đường vào ca đánh sữa; Đánh nóng tạo form sữa.; Cho cà phê ép vào ly.; Rót sữa đã đánh vào ly và art.
Cà phê|CAPUCHINO NÓNG|Cafe ép=30 ml; Sữa tươi=150 ml; Kem béo=20 ml; Đường riêng=10 ml|Cho sữa tươi, kem béo và đường vào ca đánh sữa; Đánh nóng tạo form sữa.; Cho cà phê ép vào ly.; Rót sữa đã đánh vào ly và art.
Cà phê|CÀ PHÊ YẾN MẠCH|Sữa yến mạch=100 ml; Sữa đặc=30 ml; Kem béo=10 ml; Cafe ép=30 ml; Thạch sương sáo=2 muỗng|Cho sữa yến mạch, sữa đặc và kem béo vào ly.; Khuấy đều.; Cho đá vào 2/3 lý - Rót cà phê ép lên - cho 2 muỗng thạch s.sáo
Cà phê|CACAO ĐÁ|Sữa tươi=50 ml; Sữa đặc=30 ml; Cacao=Nữa muỗng|Cho sữa tươi, sữa đặc và cacao vào ly; Khuấy hoặc đánh cho cacao tan.; Cho đá vào ly.
Cà phê|CACAO NÓNG|Sữa tươi=150 ml; Sữa đặc=30 ml; Nước sôi=30 ml; Cacao=Nữa muỗng|Hòa cacao với nước sôi.; Cho sữa tươi và sữa đặc vào.; Đánh nóng hoặc khuấy nóng.; Rót ra ly.
Cà phê|MATCHA LATTE YẾN MẠCH|Sữa yến mạch=120 ml; Sữa đặc=30 ml; Sữa yến mạch đánh matcha=40 ml; Matcha=4 g|Đánh matcha với phần sữa yến mạch cho tan.; Cho sữa yến mạch và sữa đặc vào ly.; Cho đá vào -Rót matcha lên trên.
Cà phê|PHINDI HẠNH NHÂN|Syrup hạnh nhân=10 ml; Sữa tươi=50 ml; Rich=10 ml; Đường nước=10 ml; Cafe phin=15 ml; Thạch cafe=2 muỗng|Cho syrup hạnh nhân, sữa tươi, Rich và đường vào ly; Đánh hoặc lắc đều.; Cho thạch cà phê vào ly.; Cho đá và hỗn hợp sữa vào.; Cho cà phê phin sau cùng để chia tầng.
Cà phê|CÀ PHÊ SỮA ĐÁ PHIN|Phin pha sẵn=40 ml; Sữa đặc=20 ml|Cho sữa đặc vào ly.; Cho cà phê phin vào.; Khuấy đều.; Cho đá vào ly
Cà phê|CÀ PHÊ PHIN ĐEN NÓNG|Bột cà phê=25 gr; Đường=1 gói; Nước sôi=80 ml (20 ml nước ủ, 60ml nước chế cf)|Cân 25g cà phê vào phin nhôm.; Lắc nhẹ cho cà phê trải đều.; Cho 20ml nước sôi vào ủ 5-10 giây.; Cho tiếp 60ml nước sôi để chiết xuất.; Phục vụ nóng với đường riêng.
Cà phê|CÀ PHÊ PHIN SỮA NÓNG|Bột cà phê=25 gr; Sữa đặc=20 ml; Nước sôi=80 ml (20 ml nước ủ, 60ml nước chế cf)|Cho sữa đặc vào ly.; Cân 25g cà phê vào phin nhôm và lắc nhẹ.; Cho 20ml nước sôi vào ủ 5-10 giây.; Cho tiếp 60ml nước sôi để chiết xuất.; cho sữa đặc vào ly và để phin nhôm lên trên
Cà phê|CÀ PHÊ ĐEN ĐÁ PHIN|Phin pha sẵn=40 ml; Đường vàng=4 g|Cho cà phê phin và đường vào ly.; Khuấy tan đường.; Cho đá vào ly.; Khuấy nhẹ trước khi phục vụ.
Trà Thanh nhiệt|TRÀ ATISO ĐỎ HẠT CHIA|Nước cốt=160 ml; Cốt chanh=10 ml; Hạt chia=2 muỗng|Cho tất cả nguyên liệu vào shaker.; Thêm đá và lắc đều.; Đổ ra ly.; Decor chanh và lá húng.
Trà Thanh nhiệt|CHANH SẢ GỪNG HẠT CHIA|Nước cốt=160 ml; Cốt chanh=10 ml; Hạt chia=2 muỗng|Cho tất cả nguyên liệu vào shaker.; Thêm đá và lắc đều.; Đổ ra ly.; Decor chanh và lá húng.
Trà Thanh nhiệt|TRÀ HOA ĐẬU BIẾC HẠT CHIA|Nước cốt=160 ml; Cốt chanh=10 ml; Hạt chia=2 muỗng; Việt quất=30 ml|Cho tất cả nguyên liệu vào shaker.; Thêm đá và lắc đều.; Đổ ra ly.; Decor chanh và lá húng.
Trà Thanh nhiệt|TRÀ ĐÀO HẠT CHIA|Nước cốt=160 ml; Hạt chia=2 muỗng|Cho tất cả nguyên liệu vào shaker.; Thêm đá và lắc đều.; Đổ ra ly.; Decor 3 lát đào và lá húng.
Trà Thanh nhiệt|TRÀ ĐÀO CAM SẢ|Nước cốt=120 ml; Cốt chanh=10 ml; Nước cam=10 ml; Monin sả=15 ml|Cho tất cả nguyên liệu vào shaker.; Thêm đá và lắc đều.; Đổ ra ly.; Decor 2 lát đào, 1 lát cam, 3 miếng sả và lá húng.
Trà Thanh nhiệt|TRÀ THẢO MỘC HẠT CHIA|Nước cốt=160 ml; Củ năng=1 củ; Hạt chia=2 muỗng; Thạch sương sáo=2 muỗng|Cho nước cốt thảo mộc vào ly.; Cho đá 2/3 ly.; Cho hạt chia, thạch sương sáo và củ năng cắt nhỏ vào.; Cho phần cái của cốt thảo mộc lên trên.
Trà Thanh nhiệt|SỮA TƯƠI HOA ĐẬU BIẾC|Nước cốt=60 ml; Sữa tươi=50 ml; Đường=10 ml; Rich=20 ml; Hạt chia=2 muỗng; Củ năng=1 củ; Thạch sương sáo=1 muỗng|Cho cốt hoa đậu biếc lá dứa và đường vào ly.; Cho đá 2/3 ly.; Cho sữa tươi vào đã được khoáy đều với rich vào ly; Cho hạt chia, thạch sương sáo và củ năng cắt nhỏ vào.
Trà Thanh nhiệt|TRÀ SỮA OOLONG|Nước cốt=160 ml; Thạch cà phê=2 muỗng; Trân châu trắng=2 muỗng|Cho nước cốt trà sữa oolong vào.; Cho đá 2/3 ly.; Cho topping vào ly.
Trà Thanh nhiệt|CHANH MUỐI MẬT ONG|Mứt chanh muối=40 ml; Nước lọc=80 ml; Chanh=10 ml; Mật ong=15 ml|Cho tất cả nguyên liệu vào shaker.; Thêm đá và lắc đều.; Đổ ra ly.; Decor chanh và lá húng.
Trà Thanh nhiệt|MATCHA MÃNG CẦU|Hỗn hợp matcha=40 ml; Mứt mãng cầu=40 ml; Đường=30 ml; Nước lọc=50 ml; Muối=0.1 g|Cho tất cả nguyên liệu khoáy đều trừ hỗn hợp matcha - cho ra ly - cho 2,7/3 đá; khoáy hổn hợp matcha : 40m nước sôi - 2g matcha - cho vào ly; Decor chanh và lá húng.
Trà Thanh nhiệt|TRÀ VẢI HOA HỒNG|Trà lài=100 ml; Syrup vải=40 ml; Nước đường=20 ml; Cốt chanh=10 ml|Cho tất cả nguyên liệu vào shaker.; Thêm đá và lắc đều.; Đổ ra ly.; Decor 3 quả vải,  chanh và lá húng.
Trà Thanh nhiệt|TRÀ DƯA LƯỚI|Trà lài=100 ml; Mứt dưa lưới=30 ml; Syrup dưa lưới=10 ml; Nước đường=10 ml; Cốt chanh=10 ml|Cho tất cả nguyên liệu vào shaker.; Thêm đá và lắc đều.; Đổ ra ly.; Decor 2 vá trân châu,  chanh và lá húng.
Trà Thanh nhiệt|TRÀ TÁO XANH|Trà lài=30 ml; Syrup táo=20 ml; Nước đường=10 ml; nước ép táo=20 ml; Nước lọc=40 ml|Cho tất cả nguyên liệu vào shaker.; Thêm đá và lắc đều.; Đổ ra ly.; Decor 3 lát táo và lá húng.
Trà Thanh nhiệt|TRÀ DÂU TẰM|Trà lài=100 ml; Mứt dâu tằm=30 ml; Sinh tố dâu tằm=20 ml; Đường nước=15 ml; Tắc=5 ml|Cho tất cả nguyên liệu vào shaker.; Thêm đá và lắc đều.; Đổ ra ly.; Decor 1 vá trân châu, 3 quả dâu tằm và lá húng.
Trà Thanh nhiệt|TRÀ LÀI ĐÁC THƠM|Trà lài=100 ml; Chanh=10 ml; Nước đường=30 ml; Đác Thơm=2 muỗng|Cho tất cả nguyên liệu vào shaker.; Thêm đá và lắc đều.; Đổ ra ly.; Decor chanh và lá húng.
Trà Thanh nhiệt|TRÀ MÃNG CẦU HẠT ĐÁC|Trà lài=100 ml; Chanh=10 ml; Nước đường=30 ml; Mứt mãng cầu=30 ml; Hạt đác=10 cục|Cho trà lài, chanh, nước đường và mứt mãng cầu vào shaker.; Thêm đá và lắc đều.; Đổ ra ly.; Cho 10 hạt đác lên trên.; Decor chanh và lá húng.
Trà Thanh nhiệt|TRÀ MẬN|Trà lài=120 ml; Chanh=10 ml; Nước đường=15 ml; Mứt mận=50 ml|Cho tất cả nguyên liệu vào shaker.; Thêm đá và lắc đều.; Đổ ra ly.; Decor 1 vá trân châu,  chanh và lá húng.
Trà Thanh nhiệt|TRÀ THẠCH ĐÀO|Trà cozy đào=2 gói; Nước sôi=130 ml; Nước đường=40 ml; Rich=40 ml; Đào miếng=2 lát; Thạch đào=3 lát|Ngâm 2 gói trà cozy đào với 130ml nước sôi trong 2 phút.; Cho 40ml đường và 80ml trà vào ly rồi khuấy đều.; Cho đá 2/3 ly.; Khuấy 50ml trà còn lại với 40ml Rich rồi rót vào ly.; Decor 2 lát đào và 3 lát thạch.
Trà Thanh nhiệt|TRÀ SEN VÀNG|Trà olong cầu tre=2 gói; Nước sôi=130 ml; Nước đường=30 ml; Hạt sen=10 hạt; Kem muối=2 muỗng|Ngâm 2 gói olong cầu tre với 130ml nước sôi trong 2 phút.; Làm lạnh cốt oolong.; Cho 10 hạt sen và 30ml đường vào ly.; Cho cốt oolong vào và khuấy đều.; Cho đá 2/3 ly.; Phủ 2 muỗng kem muối.
Trà Thanh nhiệt|TRÀ GỪNG|Trà=1 gói; Nước sôi=180 ml; Mật ong=15 ml; Gừng=4-5 lát băm nhỏ|Cho gói trà,  mật ong và gừng vào ly.; Rót trà vào ly; Phục vụ nóng
Trà Thanh nhiệt|NƯỚC CHANH|Cốt chanh=40 ml; Nước đường=40 ml; Nước lọc=80 ml; Muối=1 g|Cho tất cả nguyên liệu vào shaker.; Thêm đá và lắc đều.; Đổ ra ly.; Decor chanh và lá húng.
Đá xay & sinh tố|SINH TỐ BƠ|Bơ=200 g; Sữa tươi=50 ml; Sữa đặc=30 ml; Nước đường=20 ml; Đá=150 g|Cho toàn bộ nguyên liệu vào máy xay.; Xay mịn.; Đổ ra ly.; Decor lá húng.
Đá xay & sinh tố|SINH TỐ XOÀI|Xoài=100 g; Sữa tươi=40 ml; Nước đường=20 ml; Sữa đặc=20 ml; Sirup chanh dây=20 ml; Nước lọc=40 ml; Đá=150 g|Cho toàn bộ nguyên liệu vào máy xay.; Xay mịn.; Đổ ra ly.; Decor xoài cắt hạt lựu và lá húng.
Đá xay & sinh tố|SINH TỐ DỪA|Cơm dừa=80 g; Sữa đặc=30 ml; Đường nước=20 ml; Sữa tươi=30 ml; Nước dừa=100 ml; Đá=150 g|Cho toàn bộ nguyên liệu vào máy xay.; Xay mịn.; Đổ ra ly.; Decor dừa khô và lá húng.; nước dừa còn dư cho vào ly mang ra cho khách
Đá xay & sinh tố|BƠ GIÀ DỪA NON|Phần cốt dừa=cốt dừa 60ml, sữa tươi 20ml, sữa đặc 20ml, nước đường 5ml; Phần bơ=bơ 80g, nước lọc 60ml, sữa đặc 30ml, nước đường 5ml|Cho phần cốt dừa nằm dưới đáy ly.; Cho đá 1/2 ly.; Xay phần bơ mịn.; Cho phần bơ lên trên.; Decor dừa khô.
Đá xay & sinh tố|MATCHA ĐÁ XAY|Bột matcha=8 g; Nước đường=10 ml; Sữa đặc=40 ml; Sữa tươi=60 ml; Bột frap=14 g; Richs=20 ml; Đá=150 g|Cho toàn bộ nguyên liệu vào máy xay.; Xay mịn.; Đổ ra ly.; Cho kem tươi lên trên.; Rắc bột matcha  lên kem.
Đá xay & sinh tố|CACAO ĐÁ XAY|Cacao=8 g; Nước đường=10 ml; Sữa đặc=40 ml; Sữa tươi=60 ml; Bột frap=14 g; Richs=10 ml; Đá=150 g|Cho toàn bộ nguyên liệu vào máy xay.; Xay mịn.; Đổ ra ly.; Cho kem tươi lên trên.; Rắc bột cacao lên kem.
Đá xay & sinh tố|MÃNG CẦU TUYẾT|Sữa chua=nữa hủ; Sữa đặc=30 ml; Sữa tươi=50 ml; Bột frap=1 muỗng; Tắc=2 trái; Mứt mãng cầu=50 ml|Cho toàn bộ nguyên liệu vào máy xay.; Xay mịn.; Đổ ra ly.; Decor lá húng và chanh.
Đá xay & sinh tố|VIỆT QUẤT ĐÁ XAY|Sữa chua=nữa hủ; Sữa đặc=30 ml; Sữa tươi=50 ml; Bột frap=1 muỗng; Tắc=2 trái; Mứt việt quất=50 ml|Cho toàn bộ nguyên liệu vào máy xay.; Xay mịn.; Đổ ra ly.; Decor lá húng và chanh.
Đá xay & sinh tố|DÂU TẰM ĐÁ XAY|Sữa chua=nữa hủ; Sữa đặc=30 ml; Sữa tươi=50 ml; Bột frap=1 muỗng; Tắc=2 trái; Mứt dâu tằm=50 ml|Cho toàn bộ nguyên liệu vào máy xay.; Xay mịn.; Đổ ra ly.; Decor lá húng và chanh.
Đá xay & sinh tố|DÂU TÂY ĐÁ XAY|Sữa chua=nữa hủ; Sữa đặc=30 ml; Sữa tươi=50 ml; Bột frap=1 muỗng; Tắc=2 trái; Mứt dâu tây=50 ml|Cho toàn bộ nguyên liệu vào máy xay.; Xay mịn.; Đổ ra ly.; Decor lá húng và chanh.
Đá xay & sinh tố|SỮA CHUA HẠT ĐÁC|Sữa chua=1 hủ; Sữa tươi=20 ml; Sữa đặc=30 ml; Tắc=2 trái; Đác thơm=2 muỗng|Cho toàn bộ nguyên liệu vào ly; Trộn đều.; Decor chanh và lá húng.
Đá xay & sinh tố|SỮA CHUA DÂU TẰM|Sữa chua=1 hủ; Sữa tươi=20 ml; Sữa đặc=30 ml; Tắc=2 trái; Mứt dâu tằm=40 ml|Cho toàn bộ nguyên liệu vào ly; Trộn đều.; Decor chanh và lá húng.
Đá xay & sinh tố|SỮA CHUA VIỆT QUẤT|Sữa chua=1 hủ; Sữa tươi=20 ml; Sữa đặc=30 ml; Tắc=2 trái; Mứt việt quất=40 ml|Cho toàn bộ nguyên liệu vào ly; Trộn đều.; Decor chanh và lá húng.
Đá xay & sinh tố|SỮA CHUA DÂU TÂY|Sữa chua=1 hủ; Sữa tươi=20 ml; Sữa đặc=30 ml; Tắc=2 trái; Mứt dâu tây=40 ml|Cho toàn bộ nguyên liệu vào ly; Trộn đều.; Decor chanh và lá húng.
Đá xay & sinh tố|SỮA CHUA MÃNG CẦU|Sữa chua=1 hủ; Sữa tươi=20 ml; Sữa đặc=30 ml; Tắc=2 trái; Mứt mãng cầu=40 ml|Cho toàn bộ nguyên liệu vào ly; Trộn đều.; Decor chanh và lá húng.
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
