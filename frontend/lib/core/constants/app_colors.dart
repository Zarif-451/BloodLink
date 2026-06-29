import 'package:flutter/material.dart';

/// Raw design tokens — prefer [Theme.of] / [BloodlinkColors] in widgets.
abstract final class AppColors {
  static const primary = Color(0xFFC62828);
  static const primaryDark = Color(0xFFEF5350);
  static const primaryLight = Color(0xFFFFEBEE);
  static const surface = Color(0xFFFFFFFF);
  static const background = Color(0xFFF5F5F5);
  static const textPrimary = Color(0xFF212121);
  static const textSecondary = Color(0xFF757575);
  static const success = Color(0xFF2E7D32);
  static const warning = Color(0xFFF9A825);
  static const critical = Color(0xFFB71C1C);
  static const info = Color(0xFF1565C0);

  static const darkBackground = Color(0xFF111318);
  static const darkSurface = Color(0xFF1A1D24);
  static const darkSurfaceElevated = Color(0xFF232830);
}
