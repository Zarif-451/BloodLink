import 'package:flutter/material.dart';

import 'bloodlink_colors.dart';

/// BloodLink design tokens — Crimson Clinical (chosen theme).
abstract final class AppTheme {
  static const primary = Color(0xFFC62828);
  static const primaryDark = Color(0xFFEF5350);
  static const radius = 12.0;

  static ThemeData get light => _build(brightness: Brightness.light);

  static ThemeData get dark => _build(brightness: Brightness.dark);

  static ThemeData _build({required Brightness brightness}) {
    final isDark = brightness == Brightness.dark;

    final background = isDark ? const Color(0xFF111318) : const Color(0xFFF5F5F5);
    final surface = isDark ? const Color(0xFF1A1D24) : Colors.white;
    final onSurface = isDark ? const Color(0xFFE8EAED) : const Color(0xFF212121);
    final primaryColor = isDark ? primaryDark : primary;
    final accent = primaryColor;
    final primaryLight =
        isDark ? const Color(0xFF3D1F1F) : const Color(0xFFFFEBEE);

    final scheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: brightness,
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: accent,
      surface: surface,
      onSurface: onSurface,
    ).copyWith(
      surfaceContainerHighest: isDark ? const Color(0xFF232830) : background,
      outline: onSurface.withValues(alpha: isDark ? 0.25 : 0.15),
    );

    final borderColor = onSurface.withValues(alpha: isDark ? 0.12 : 0.08);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: surface,
        foregroundColor: onSurface,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(color: borderColor),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius - 4),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(color: primaryColor.withValues(alpha: 0.5)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius - 4),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF232830) : surface,
        labelStyle: TextStyle(color: onSurface.withValues(alpha: 0.7)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius - 4),
          borderSide: BorderSide(color: onSurface.withValues(alpha: 0.15)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius - 4),
          borderSide: BorderSide(color: onSurface.withValues(alpha: 0.15)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius - 4),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius - 2),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          side: WidgetStatePropertyAll(
            BorderSide(color: onSurface.withValues(alpha: 0.15)),
          ),
        ),
      ),
      extensions: [
        BloodlinkColors(
          success: isDark ? const Color(0xFF66BB6A) : const Color(0xFF2E7D32),
          warning: isDark ? const Color(0xFFFFB74D) : const Color(0xFFF9A825),
          critical: isDark ? const Color(0xFFEF5350) : const Color(0xFFB71C1C),
          info: isDark ? const Color(0xFF64B5F6) : const Color(0xFF1565C0),
          primaryLight: primaryLight,
          accent: accent,
        ),
      ],
    );
  }
}
