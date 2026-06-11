import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color tripBlue = Color(0xFF3264FF);
  static const Color deepBlue = Color(0xFF12315F);
  static const Color skyBlue = Color(0xFFEAF1FF);
  static const Color pageBackground = Color(0xFFF5F7FB);
  static const Color softYellow = Color(0xFFFFB72B);
  static const Color coral = Color(0xFFFF5A7A);
  static const Color textPrimary = Color(0xFF10233F);
  static const Color textSecondary = Color(0xFF66758F);

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: tripBlue,
      primary: tripBlue,
      secondary: softYellow,
      surface: Colors.white,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: pageBackground,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: tripBlue,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        selectedColor: skyBlue,
        side: BorderSide.none,
        labelStyle: const TextStyle(
          color: textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF2F5FA),
        hintStyle: const TextStyle(color: textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: tripBlue, width: 1.4),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}
