import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1E40AF);
  static const Color primaryDark = Color(0xFF1E3A8A);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryContainer = Color(0xFFEFF6FF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF8FAFC);
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderSubtle = Color(0xFFF1F5F9);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color success = Color(0xFF059669);
  static const Color successContainer = Color(0xFFECFDF5);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.primaryDark,
        secondary: AppColors.primaryLight,
        onSecondary: Colors.white,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: Color(0xFFDC2626),
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.primaryDark),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primaryContainer,
        labelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(44, 46),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.border),
          minimumSize: const Size(44, 46),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
