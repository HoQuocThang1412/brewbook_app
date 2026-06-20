import 'package:flutter/material.dart';

/// Bảng màu chủ đạo cho BrewBook: trắng - kem - nâu cà phê - vàng nhạt.
class AppColors {
  AppColors._();

  static const Color background = Color(0xFFFBF6EE); // nền kem sáng
  static const Color surface = Color(0xFFFFFFFF); // trắng cho card
  static const Color surfaceAlt = Color(0xFFF4EAD9); // kem đậm hơn cho nền phụ

  static const Color coffeeDark = Color(0xFF3E2B1F); // nâu cà phê đậm - tiêu đề
  static const Color coffeeBrown = Color(0xFF6F4A30); // nâu cà phê chính
  static const Color coffeeLight = Color(0xFFB58863); // nâu nhạt

  static const Color gold = Color(0xFFD8A24A); // vàng nhạt - nhấn
  static const Color goldSoft = Color(0xFFF1D9A6); // vàng rất nhạt - nền chip

  static const Color textPrimary = Color(0xFF3B2A1E);
  static const Color textSecondary = Color(0xFF8C7763);
  static const Color textOnDark = Color(0xFFFBF6EE);

  static const Color success = Color(0xFF6E8B5C);
  static const Color successSoft = Color(0xFFE3ECDB);
  static const Color danger = Color(0xFFBD5A45);
  static const Color dangerSoft = Color(0xFFF6E1DB);

  static const Color border = Color(0xFFE8DCC8);
  static const Color shadow = Color(0x1A3E2B1F);
}
