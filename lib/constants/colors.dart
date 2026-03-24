import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary (from Figma - vibrant blue/indigo)
  static const Color primary = Color(0xFF4B3FF5);
  static const Color primaryLight = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF3A2FD4);

  // Gradient (Splash & Onboarding)
  static const Color gradientStart = Color(0xFF4B3FF5);
  static const Color gradientEnd = Color(0xFF7B61FF);

  // Light theme
  static const Color background = Color(0xFFF5F6FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color cardBorder = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFF0F0F0);
  static const Color navInactive = Color(0xFF9CA3AF);

  // Dark theme
  static const Color darkBackground = Color(0xFF121218);
  static const Color darkSurface = Color(0xFF1E1E2A);
  static const Color darkTextPrimary = Color(0xFFE8E8ED);
  static const Color darkTextSecondary = Color(0xFF9CA3B0);
  static const Color darkTextHint = Color(0xFF6B7280);
  static const Color darkCardBorder = Color(0xFF2D2D3A);
  static const Color darkDivider = Color(0xFF2A2A36);
  static const Color darkNavInactive = Color(0xFF6B7280);

  // Accent (shared)
  static const Color amber = Color(0xFFF5A623);
  static const Color green = Color(0xFF22C55E);
  static const Color red = Color(0xFFEF4444);

  // Habit colors (for user selection)
  static const List<Color> habitColors = [
    Color(0xFF4B3FF5),
    Color(0xFFEF4444),
    Color(0xFFF5A623),
    Color(0xFF22C55E),
    Color(0xFF3B82F6),
    Color(0xFFEC4899),
    Color(0xFF8B5CF6),
    Color(0xFF14B8A6),
  ];

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientStart, gradientEnd],
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF4B3FF5),
      Color(0xFF6347F5),
      Color(0xFF7B61FF),
    ],
  );
}

/// Theme-aware color accessor via BuildContext
extension ThemeColors on BuildContext {
  bool get _isDark => Theme.of(this).brightness == Brightness.dark;

  Color get bg => _isDark ? AppColors.darkBackground : AppColors.background;
  Color get card => _isDark ? AppColors.darkSurface : AppColors.surface;
  Color get textP => _isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
  Color get textS => _isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
  Color get textH => _isDark ? AppColors.darkTextHint : AppColors.textHint;
  Color get border => _isDark ? AppColors.darkCardBorder : AppColors.cardBorder;
  Color get div => _isDark ? AppColors.darkDivider : AppColors.divider;
  Color get navInact => _isDark ? AppColors.darkNavInactive : AppColors.navInactive;
}
