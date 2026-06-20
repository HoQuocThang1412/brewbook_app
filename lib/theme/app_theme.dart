import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.coffeeBrown,
        brightness: Brightness.light,
        primary: AppColors.coffeeBrown,
        secondary: AppColors.gold,
        surface: AppColors.surface,
      ),
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Roboto',
      visualDensity: VisualDensity.standard,
    );

    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: AppColors.border),
    );

    final textTheme = base.textTheme.apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    ).copyWith(
      titleLarge: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 22,
        height: 1.16,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.45,
      ),
      titleMedium: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 16,
        height: 1.25,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
      bodyMedium: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 14,
        height: 1.38,
        fontWeight: FontWeight.w500,
      ),
      bodySmall: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 12.5,
        height: 1.35,
        fontWeight: FontWeight.w500,
      ),
    );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w800,
          height: 1.15,
          letterSpacing: -0.45,
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.coffeeBrown, width: 1.4),
        ),
        hintStyle: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
        labelStyle: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
        prefixIconColor: AppColors.textSecondary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.coffeeBrown,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.coffeeBrown,
          side: const BorderSide(color: AppColors.border),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.coffeeBrown),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.coffeeBrown,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: AppColors.surfaceAlt,
        selectedColor: AppColors.goldSoft,
        labelStyle: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        side: const BorderSide(color: AppColors.border),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.coffeeBrown,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        titleTextStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.3,
        ),
        contentTextStyle: const TextStyle(color: AppColors.textSecondary, height: 1.38),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.border),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.coffeeBrown,
        linearTrackColor: AppColors.surfaceAlt,
      ),
      expansionTileTheme: const ExpansionTileThemeData(
        textColor: AppColors.textPrimary,
        collapsedTextColor: AppColors.textPrimary,
        iconColor: AppColors.coffeeBrown,
        collapsedIconColor: AppColors.textSecondary,
      ),
    );
  }

  static ThemeData get darkTheme => lightTheme;
}
