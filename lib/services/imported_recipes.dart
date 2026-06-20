import 'package:hive/hive.dart';

import '../models/ingredient.dart';
import '../models/recipe.dart';

const _excelRecipesSeedVersion = 'excel_recipes_seeded_v8';

String get excelRecipesSeedVersion => _excelRecipesSeedVersion;

const String _rawImportedRecipes = r'''
Nguyên liệu nền|Hạt chia|Hạt chia=30 g; nước ấm hoặc sôi=500 ml|cho ca 2 vào trộn đều
Nguyên liệu nền|Kem muối|richs=100 ml; Sữa tươi không đường=50 ml; Sữa đặc=10 ml; Muối=0.1 g; base=50 ml|Cho toàn bộ nguyên liệu vào ca lạnh.; Đánh đến khi kem sánh mịn, có vị mặn nhẹ.; Bảo quản lạnh, khuấy lại trước khi dùng.
Nguyên liệu nền|Kem tươi|richs=120 ml; Sữa tươi không đường=60 ml; base=120 ml|Cho kem béo, sữa tươi và sữa đặc vào ca sạch.; Đánh hoặc khuấy lạnh đến khi hỗn hợp mịn, hơi sánh.; Bảo quản lạnh và dùng trong ngày.
Nguyên liệu nền|Nước đường|Đường cát=750 g; Nước sôi=500 ml|Đun hoặc khuấy nước nóng với đường đến khi tan hoàn toàn.; Để nguội, lọc nếu cần.; Cho vào chai sạch và bảo quản nơi mát.
Nguyên liệu nền|Trà lài|Trà lài=20 g; Nước sôi=500 ml; Đá=500 g|trán trà bằng nước sôi - Ủ trà lài với nước sôi 15p; Lọc bỏ xác trà. bằng ray và khăn lọc; Làm lạnh nhanh bằng đá để giữ hương trà.
Cà phê|Cà phê muối|Phin pha sẵn=35 ml; Sữa tươi=20 ml; Sữa đặc=20 ml; Kem muối=2-4 muỗng|Cho sữa đặc và sữa tươi vào ly.; Cho cà phê phin vào và khuấy nhẹ và cho đá vào; Phủ kem muối lên trên. - rắc bột cacao phủ kem muối
Cà phê|Cà phê đen ép nóng|Cafe ép=45 ml; Đường vàng=4 gr|Chiết xuất cà phê ép.; Cho đường gói vào đĩa; cho ly cafe đã được chiết xuất lên đĩa
Cà phê|Cà phê sữa ép nóng|Cafe ép=45 ml; Sữa đặc=20 ml|Cho sữa đặc vào ly.; Chiết xuất cà phê ép nóng.; Rót cà phê lên sữa.; Khuấy đều.
Cà phê|Cà phê đen đá ép|Cafe ép=45 ml; Đường vàng=4 gr (khuấy tan)|Chiết xuất cà phê ép.; Làm lạnh cà phê.; Cho đường vàng vào cà phê và khuấy tan.; Cho đá vào ly.; Rót cà phê đã làm lạnh vào ly.
Cà phê|Cà phê sữa đá ép|Cafe ép=45 ml; Sữa đặc=20 ml|Chiết xuất cà phê ép.; Làm lạnh cà phê.; Cho sữa đặc vào ly.; Rót cà phê đã làm lạnh lên sữa.; Khuấy đều hoặc phục vụ theo kiểu chia tầng tùy yêu cầu.
Cà phê|Bạc xỉu|Cafe phin=30 ml; Sữa tươi=50 ml; Sữa đặc=30 ml|Cho sữa đặc và sữa tươi vào đáy ly.; Khuấy đều phần sữa.; Cho đá vào ly.; Đánh bọt cà phê phin.; Rót cà phê đã đánh bọt lên trên để tạo 2 tầng sữa dưới cà phê trên.
Cà phê|Latte đá|Cafe ép=30 ml; Sữa tươi=90 ml; Kem béo=20 ml; Đường=10 ml|Cho sữa tươi, kem béo và đường vào shaker, chưa cho cà phê.; Thêm đá và lắc đều cho hỗn hợp lạnh.; Đổ hỗn hợp sữa ra ly.; Rót cà phê ép lên trên cùng để tạo tầng.; Kiểm tra lớp cà phê nổi đẹp rồi phục vụ.
Cà phê|Capuchino đá|Cafe ép=30 ml; Sữa tươi=70 ml; Kem béo=20 ml; Đường=10 ml|Cho sữa tươi, kem béo và đường vào shaker, chưa cho cà phê.; Thêm đá và lắc đều để tạo độ lạnh và độ bông nhẹ.; Đổ hỗn hợp ra ly.; Rót cà phê ép lên trên cùng.; Giữ lớp cà phê phía trên rõ tầng trước khi phục vụ.
Cà phê|Latte nóng|Cafe ép=30 ml; Sữa tươi=150 ml; Kem béo=20 ml; Đường riêng=10 ml|Cho sữa tươi, kem béo và đường vào ca đánh sữa, chưa cho cà phê.; Đánh nóng tạo form sữa mịn.; Chiết xuất cà phê ép vào ly.; Rót sữa đã đánh vào ly và art trên mặt.; Lau miệng ly sạch trước khi phục vụ.
Cà phê|Capuchino nóng|Cafe ép=30 ml; Sữa tươi=150 ml; Kem béo=20 ml; Đường riêng=10 ml|Cho sữa tươi, kem béo và đường vào ca đánh sữa, chưa cho cà phê.; Đánh nóng tạo form sữa dày hơn latte.; Chiết xuất cà phê ép vào ly.; Rót sữa đã đánh vào ly và art trên mặt.; Phục vụ nóng ngay sau khi làm xong.
Cà phê|Cà phê yến mạch|Sữa yến mạch=100 ml; Sữa đặc=30 ml; Kem béo=10 ml; Cafe ép=30 ml; Thạch sương sáo=2 muỗng|Cho sữa yến mạch, sữa đặc và kem béo vào ly.; Khuấy đều phần sữa.; Cho thạch sương sáo vào ly.; Cho đá vào khoảng 2/3 ly.; Rót cà phê ép lên sau cùng để chia tầng.
Cà phê|Cacao đá|Sữa tươi=50 ml; Sữa đặc=30 ml; Cacao=Nữa muỗng|Cho sữa tươi, sữa đặc và cacao vào ca.; Khuấy hoặc đánh cho cacao tan đều.; Cho đá vào ly.; Rót hỗn hợp cacao vào ly.; Kiểm tra bột cacao không bị vón trước khi phục vụ.
Cà phê|Cacao nóng|Sữa tươi=150 ml; Sữa đặc=30 ml; Nước sôi=30 ml; Cacao=Nữa muỗng|Hòa cacao với nước sôi cho tan mịn.; Cho sữa tươi và sữa đặc vào ca.; Đánh nóng hoặc khuấy nóng hỗn hợp.; Rót ra ly.; Phục vụ nóng.
Cà phê|Matcha latte yến mạch|Sữa yến mạch=120 ml; Sữa đặc=30 ml; Sữa yến mạch đánh matcha=40 ml; Matcha=4 g|Đánh matcha với phần sữa yến mạch đánh matcha cho tan mịn.; Cho sữa yến mạch và sữa đặc vào ly.; Khuấy đều phần sữa.; Cho đá vào ly nếu làm lạnh.; Rót matcha lên trên để tạo tầng.
Cà phê|Phindi hạnh nhân|Syrup hạnh nhân=10 ml; Sữa tươi=50 ml; Rich=10 ml; Đường nước=10 ml; Cafe phin=15 ml; Thạch cafe=2 muỗng|Cho syrup hạnh nhân, sữa tươi, Rich và đường nước vào ca, chưa cho cà phê và thạch.; Đánh hoặc lắc đều hỗn hợp sữa.; Cho thạch cà phê vào ly.; Cho đá vào ly.; Rót hỗn hợp sữa vào trước.; Cho cà phê phin sau cùng để chia tầng.
Cà phê|Cà phê sữa đá phin|Phin pha sẵn=40 ml; Sữa đặc=20 ml|Cho sữa đặc vào ly.; Cho cà phê phin pha sẵn vào ly.; Khuấy đều cho sữa và cà phê hòa quyện.; Cho đá vào ly và phục vụ.
Cà phê|Cà phê phin đen nóng|Bột cà phê=25 gr; Đường=1 gói; Nước sôi=80 ml (20 ml nước ủ, 60ml nước chế cf)|Cân 25g cà phê vào phin nhôm.; Lắc nhẹ cho cà phê trải đều mặt phin.; Cho 20ml nước sôi vào ủ cà phê 5-10 giây.; Cho tiếp 60ml nước sôi để chiết xuất cà phê.; Cho đường riêng hoặc phục vụ theo yêu cầu khách.
Cà phê|Cà phê phin sữa nóng|Bột cà phê=25 gr; Sữa đặc=20 ml; Nước sôi=80 ml (20 ml nước ủ, 60ml nước chế cf)|Cho sữa đặc vào đáy ly.; Cân 25g cà phê vào phin nhôm và lắc nhẹ cho cà phê trải đều.; Cho 20ml nước sôi vào ủ 5-10 giây.; Cho tiếp 60ml nước sôi để chiết xuất cà phê.; Khi cà phê chảy xong thì khuấy đều với sữa đặc và phục vụ nóng.
Cà phê|Cà phê đen đá phin|Phin pha sẵn=40 ml; Đường vàng=4 g|Cho cà phê phin và đường vào ly.; Khuấy tan đường.; Cho đá vào ly.; Khuấy nhẹ trước khi phục vụ.
Trà Thanh nhiệt|Trà atiso đỏ hạt chia|Nước cốt=160 ml; Cốt chanh=10 ml; Hạt chia=2 muỗng|Cho tất cả nguyên liệu vào shaker.; Thêm đá và lắc đều.; Đổ ra ly.; Decor chanh và lá húng.
Trà Thanh nhiệt|Chanh sả gừng hạt chia|Nước cốt=160 ml; Cốt chanh=10 ml; Hạt chia=2 muỗng|Cho tất cả nguyên liệu vào shaker.; Thêm đá và lắc đều.; Đổ ra ly.; Decor chanh và lá húng.
Trà Thanh nhiệt|Trà hoa đậu biếc hạt chia|Nước cốt=160 ml; Cốt chanh=10 ml; Hạt chia=2 muỗng; Việt quất=30 ml|Cho tất cả nguyên liệu vào shaker.; Thêm đá và lắc đều.; Đổ ra ly.; Decor chanh và lá húng.
Trà Thanh nhiệt|Trà đào hạt chia|Nước cốt=160 ml; Hạt chia=2 muỗng|Cho tất cả nguyên liệu vào shaker.; Thêm đá và lắc đều.; Đổ ra ly.; Decor chanh và lá húng.
Trà Thanh nhiệt|Trà đào cam sả|Nước cốt=120 ml; Cốt chanh=10 ml; Nước cam=10 ml; Monin sả=15 ml|Cho tất cả nguyên liệu vào shaker.; Thêm đá và lắc đều.; Đổ ra ly.; Decor chanh, cam hoặc lá húng nếu có.
Trà Thanh nhiệt|Trà thảo mộc hạt chia|Nước cốt=160 ml; Củ năng=1 củ; Hạt chia=2 muỗng; Thạch sương sáo=2 muỗng|Cho nước cốt thảo mộc vào ly trước.; Cho đá vào khoảng 2/3 ly.; Cho hạt chia vào ly.; Cho thạch sương sáo vào ly.; Cắt nhỏ 1 củ năng rồi cho vào ly.; Cho phần cái của cốt thảo mộc lên trên cùng.
Trà Thanh nhiệt|Sữa tươi hoa đậu biếc|Nước cốt=60 ml; Sữa tươi=50 ml; Đường=10 ml; Rich=20 ml; Hạt chia=2 muỗng; Củ năng=1 củ; Thạch sương sáo=1 muỗng|Cho 60ml cốt hoa đậu biếc lá dứa và 10ml đường vào ly.; Cho đá vào khoảng 2/3 ly.; Cho 50ml sữa tươi vào ly.; Cho hạt chia vào ly.; Cho thạch sương sáo vào ly.; Cắt nhỏ 1 củ năng rồi cho vào ly.; Rót Rich nếu cần tạo độ béo và kiểm tra tầng màu.
Trà Thanh nhiệt|Trà sữa oolong|Nước cốt=160 ml; Thạch cà phê=2 muỗng; Trân châu trắng=2 muỗng|Cho thạch cà phê và trân châu trắng vào ly.; Cho nước cốt trà sữa oolong vào ly.; Cho đá vào khoảng 2/3 ly.; Khuấy nhẹ cho lạnh đều.; Kiểm tra topping nằm đều trước khi phục vụ.
Trà Thanh nhiệt|Chanh muối mật ong|Mứt chanh muối=40 ml; Nước lọc=80 ml; Chanh=10 ml; Mật ong=15 ml|Cho tất cả nguyên liệu vào shaker.; Thêm đá và lắc đều.; Đổ ra ly.; Decor chanh và lá húng.
Trà Thanh nhiệt|Matcha mãng cầu|Hỗn hợp matcha=40 ml; Mứt mãng cầu=40 ml; Đường=30 ml; Nước lọc=50 ml; Muối=0.1 g|Cho hỗn hợp matcha, mứt mãng cầu, đường, nước lọc và muối vào shaker.; Thêm đá và lắc đều.; Đổ ra ly.; Decor chanh và lá húng nếu có.; Kiểm tra mãng cầu không lắng dưới đáy.
Trà Thanh nhiệt|Trà vải hoa hồng|Trà lài=100 ml; Syrup vải=40 ml; Nước đường=20 ml; Cốt chanh=10 ml|Cho tất cả nguyên liệu vào shaker.; Thêm đá và lắc đều.; Đổ ra ly.; Decor chanh và lá húng.
Trà Thanh nhiệt|Trà dưa lưới|Trà lài=100 ml; Mứt dưa lưới=30 ml; Syrup dưa lưới=10 ml; Nước đường=10 ml; Cốt chanh=10 ml|Cho tất cả nguyên liệu vào shaker.; Thêm đá và lắc đều.; Đổ ra ly.; Decor chanh và lá húng.
Trà Thanh nhiệt|Trà táo xanh|Trà lài=30 ml; Syrup táo=20 ml; Nước đường=10 ml; Mứt táo=20 ml; Nước lọc=40 ml|Cho tất cả nguyên liệu vào shaker.; Thêm đá và lắc đều.; Đổ ra ly.; Decor chanh và lá húng.
Trà Thanh nhiệt|Trà dâu tằm|Trà lài=100 ml; Mứt dâu tằm=30 ml; Sinh tố dâu tằm=20 ml; Đường nước=15 ml; Tắc=5 ml|Cho tất cả nguyên liệu vào shaker.; Thêm đá và lắc đều.; Đổ ra ly.; Decor chanh và lá húng.
Trà Thanh nhiệt|Trà lài đác thơm|Trà lài=100 ml; Chanh=10 ml; Nước đường=30 ml; Đác Thơm=2 muỗng|Cho tất cả nguyên liệu vào shaker.; Thêm đá và lắc đều.; Đổ ra ly.; Decor chanh và lá húng.
Trà Thanh nhiệt|Trà mãng cầu hạt đác|Trà lài=100 ml; Chanh=10 ml; Nước đường=30 ml; Mứt mãng cầu=30 ml; Hạt đác=10 cục|Cho trà lài, chanh, nước đường và mứt mãng cầu vào shaker.; Thêm đá và lắc đều.; Đổ ra ly.; Cho 10 hạt đác lên trên ly.; Decor chanh và lá húng.
Trà Thanh nhiệt|Trà mận|Trà lài=120 ml; Chanh=10 ml; Nước đường=15 ml; Mứt mận=50 ml|Cho tất cả nguyên liệu vào shaker.; Thêm đá và lắc đều.; Đổ ra ly.; Decor chanh và lá húng.
Trà Thanh nhiệt|Trà thạch đào|Trà cozy đào=2 gói; Nước sôi=130 ml; Nước đường=40 ml; Rich=40 ml; Đào miếng=2 lát; Thạch đào=3 lát|Ngâm 2 gói trà cozy đào với 130ml nước sôi trong 2 phút.; Cho 40ml đường và 80ml trà vào ly rồi khuấy đều.; Cho đá vào khoảng 2/3 ly.; Lấy 50ml trà còn lại khuấy với 40ml Rich.; Rót phần trà Rich vào ly.; Decor 2 lát đào miếng và 3 lát thạch đào.
Trà Thanh nhiệt|Trà sen vàng|Trà olong cầu tre=2 gói; Nước sôi=130 ml; Nước đường=30 ml; Hạt sen=10 hạt; Kem muối=2 muỗng|Ngâm 2 gói oolong cầu tre với 130ml nước sôi trong 2 phút.; Làm lạnh phần cốt oolong đã ngâm.; Cho 10 hạt sen và 30ml đường vào ly.; Cho cốt oolong đã làm lạnh vào ly và khuấy đều.; Cho đá vào khoảng 2/3 ly.; Phủ 2 muỗng kem muối lên trên.
Trà Thanh nhiệt|Trà gừng|Trà=1 gói; Nước sôi=180 ml; Mật ong=15 ml; Gừng=4-5 lát băm nhỏ|Ủ trà với nước sôi.; Cho mật ong và gừng băm nhỏ vào ly.; Rót trà nóng vào ly và khuấy đều.; Đợi gừng ra vị rồi phục vụ.; Có thể dùng nóng hoặc làm lạnh tùy yêu cầu.
Trà Thanh nhiệt|Nước chanh|Cốt chanh=40 ml; Nước đường=40 ml; Nước lọc=80 ml; Muối=1 g|Cho tất cả nguyên liệu vào shaker.; Thêm đá và lắc đều.; Đổ ra ly.; Decor chanh và lá húng.
Đá xay & sinh tố|Sinh tố bơ|Bơ=200 g; Sữa tươi=50 ml; Sữa đặc=30 ml; Nước đường=20 ml; Đá=150 g|Cho toàn bộ nguyên liệu vào máy xay.; Xay mịn.; Đổ ra ly.; Decor lá húng.
Đá xay & sinh tố|Sinh tố xoài|Xoài=100 g; Sữa tươi=40 ml; Nước đường=20 ml; Sữa đặc=20 ml; Sirup chanh dây=20 ml; Nước lọc=40 ml; Đá=150 g|Cho toàn bộ nguyên liệu vào máy xay.; Xay mịn.; Đổ ra ly.; Decor xoài cắt hạt lựu và lá húng.
Đá xay & sinh tố|Sinh tố dừa|Cơm dừa=80 g; Sữa đặc=30 ml; Đường nước=20 ml; Sữa tươi=30 ml; Nước dừa=100 ml; Đá=150 g|Cho toàn bộ nguyên liệu vào máy xay.; Xay mịn.; Đổ ra ly.; Decor dừa khô và lá húng.
Đá xay & sinh tố|Bơ già dừa non|Phần cốt dừa=cốt dừa 60ml, sữa tươi 20ml, sữa đặc 20ml, nước đường 5ml; Phần bơ=bơ 80g, nước lọc 60ml, sữa đặc 30ml, nước đường 5ml|Chuẩn bị phần cốt dừa và cho nằm dưới đáy ly.; Cho đá vào khoảng 1/2 ly.; Xay phần bơ đến khi mịn.; Cho phần bơ lên trên phần cốt dừa.; Decor dừa khô.
Đá xay & sinh tố|Matcha đá xay|Bột matcha=8 g; Nước đường=10 ml; Sữa đặc=40 ml; Sữa tươi=60 ml; Bột frap=14 g; Richs=20 ml; Đá=150 g|Cho toàn bộ nguyên liệu vào máy xay.; Xay mịn.; Đổ ra ly.; Cho kem tươi lên trên.; Rắc bột matcha hoặc cacao nhẹ lên mặt kem tươi.
Đá xay & sinh tố|Cacao đá xay|Cacao=8 g; Nước đường=10 ml; Sữa đặc=40 ml; Sữa tươi=60 ml; Bột frap=14 g; Richs=10 ml; Đá=150 g|Cho toàn bộ nguyên liệu vào máy xay.; Xay mịn.; Đổ ra ly.; Cho kem tươi lên trên.; Rắc bột cacao lên mặt kem tươi.
Đá xay & sinh tố|Mãng cầu tuyết|Sữa chua=nữa hủ; Sữa đặc=30 ml; Sữa tươi=50 ml; Bột frap=1 muỗng; Tắc=2 trái; Mứt mãng cầu=50 ml|Cho toàn bộ nguyên liệu vào máy xay.; Xay mịn.; Đổ ra ly.; Decor lá húng và chanh.
Đá xay & sinh tố|Việt quất đá xay|Sữa chua=nữa hủ; Sữa đặc=30 ml; Sữa tươi=50 ml; Bột frap=1 muỗng; Tắc=2 trái; Mứt việt quất=50 ml|Cho toàn bộ nguyên liệu vào máy xay.; Xay mịn.; Đổ ra ly.; Decor lá húng và chanh.
Đá xay & sinh tố|Dâu tằm đá xay|Sữa chua=nữa hủ; Sữa đặc=30 ml; Sữa tươi=50 ml; Bột frap=1 muỗng; Tắc=2 trái; Mứt dâu tằm=50 ml|Cho toàn bộ nguyên liệu vào máy xay.; Xay mịn.; Đổ ra ly.; Decor lá húng và chanh.
Đá xay & sinh tố|Dâu tây đá xay|Sữa chua=nữa hủ; Sữa đặc=30 ml; Sữa tươi=50 ml; Bột frap=1 muỗng; Tắc=2 trái; Mứt dâu tây=50 ml|Cho toàn bộ nguyên liệu vào máy xay.; Xay mịn.; Đổ ra ly.; Decor lá húng và chanh.
Đá xay & sinh tố|Sữa chua hạt đác|Sữa chua=1 hủ; Sữa tươi=20 ml; Sữa đặc=30 ml; Tắc=2 trái; Đác thơm=2 muỗng|Cho toàn bộ nguyên liệu vào ly; Trộn đều.; Decor chanh và lá húng.
Đá xay & sinh tố|Sữa chua dâu tằm|Sữa chua=1 hủ; Sữa tươi=20 ml; Sữa đặc=30 ml; Tắc=2 trái; Mứt dâu tằm=40 ml|Cho toàn bộ nguyên liệu vào ly; Trộn đều.; Decor chanh và lá húng.
Đá xay & sinh tố|Sữa chua việt quất|Sữa chua=1 hủ; Sữa tươi=20 ml; Sữa đặc=30 ml; Tắc=2 trái; Mứt việt quất=40 ml|Cho toàn bộ nguyên liệu vào ly; Trộn đều.; Decor chanh và lá húng.
Đá xay & sinh tố|Sữa chua dâu tây|Sữa chua=1 hủ; Sữa tươi=20 ml; Sữa đặc=30 ml; Tắc=2 trái; Mứt dâu tây=40 ml|Cho toàn bộ nguyên liệu vào ly; Trộn đều.; Decor chanh và lá húng.
Đá xay & sinh tố|Sữa chua mãng cầu|Sữa chua=1 hủ; Sữa tươi=20 ml; Sữa đặc=30 ml; Tắc=2 trái; Mứt mãng cầu=40 ml|Cho toàn bộ nguyên liệu vào ly; Trộn đều.; Decor chanh và lá húng.
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
