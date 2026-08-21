import 'package:flutter/material.dart';

class SpcbaColors {
  // SPCBA Green Dark Theme Palette
  static const Color canvas = Color(0xFF101C14); // Deep Charcoal Green
  static const Color surface = Color(0xFF1B2E23); // Card / Container
  static const Color primary = Color(0xFF2ECC71); // Emerald Green
  static const Color secondary = Color(0xFFF1C40F); // Gold / Yellow
  static const Color onDark = Color(0xFFECEFF1); // High-contrast main text
  static const Color textSecondary = Color(0xFF94A3B8);
}

class AppTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: SpcbaColors.primary,
      brightness: brightness,
      primary: SpcbaColors.primary,
      onPrimary: isDark ? const Color(0xFF0B1220) : Colors.white,
      secondary: SpcbaColors.secondary,
      onSecondary: const Color(0xFF0B1220),
      surface: isDark ? SpcbaColors.surface : Colors.white,
      onSurface: isDark ? SpcbaColors.onDark : const Color(0xFF1A1A1A),
    );

    final Color textPrimary =
        isDark ? SpcbaColors.onDark : const Color(0xFF1A1A1A);
    final Color textSecondary =
        isDark ? SpcbaColors.textSecondary : const Color(0xFF64748B);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor:
          isDark ? SpcbaColors.canvas : const Color(0xFFF5F7FA),
      cardColor: isDark ? SpcbaColors.surface : Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? SpcbaColors.surface : const Color(0xFF1B5E20),
        foregroundColor: isDark ? SpcbaColors.onDark : Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: isDark ? SpcbaColors.surface : Colors.white,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? SpcbaColors.surface : Colors.white,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark ? SpcbaColors.surface : Colors.white,
        modalBackgroundColor: isDark ? SpcbaColors.surface : Colors.white,
        dragHandleColor: isDark
            ? SpcbaColors.textSecondary
            : const Color(0xFF94A3B8),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: textPrimary),
        bodyMedium: TextStyle(color: textPrimary),
        bodySmall: TextStyle(color: textSecondary),
        titleLarge: TextStyle(color: textPrimary),
        titleMedium: TextStyle(color: textPrimary),
        titleSmall: TextStyle(color: textPrimary),
        labelLarge: TextStyle(color: textPrimary),
        labelMedium: TextStyle(color: textSecondary),
      ),
    );
  }
}