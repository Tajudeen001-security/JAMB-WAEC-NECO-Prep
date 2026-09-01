import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF1B5E20); // Deep green (Nigeria vibe)
  static const secondary = Color(0xFF2E7D32);
  static const accent = Color(0xFFFFC107);
  static const background = Color(0xFFF5F7FA);
  static const surface = Colors.white;
  static const error = Color(0xFFD32F2F);
  static const success = Color(0xFF388E3C);
  static const textPrimary = Color(0xFF212121);
  static const textSecondary = Color(0xFF757575);
}

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          error: AppColors.error,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: AppColors.surface,
        ),
      );
}

const List<int> questionCounts = [10, 20, 30, 40];
const List<int> timePerQuestionOptions = [30, 45, 60, 90]; // seconds

const Map<String, String> examTypes = {
  'utme': 'JAMB (UTME)',
  'wassce': 'WAEC (WASSCE)',
  'neco': 'NECO',
  'post-utme': 'Post-UTME',
};
