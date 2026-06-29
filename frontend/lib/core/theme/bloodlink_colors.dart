import 'package:flutter/material.dart';

/// Semantic colors shared across BloodLink themes (status / medical UI).
class BloodlinkColors extends ThemeExtension<BloodlinkColors> {
  const BloodlinkColors({
    required this.success,
    required this.warning,
    required this.critical,
    required this.info,
    required this.primaryLight,
    required this.accent,
  });

  final Color success;
  final Color warning;
  final Color critical;
  final Color info;
  final Color primaryLight;
  final Color accent;

  static BloodlinkColors of(BuildContext context) {
    return Theme.of(context).extension<BloodlinkColors>()!;
  }

  @override
  BloodlinkColors copyWith({
    Color? success,
    Color? warning,
    Color? critical,
    Color? info,
    Color? primaryLight,
    Color? accent,
  }) {
    return BloodlinkColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      critical: critical ?? this.critical,
      info: info ?? this.info,
      primaryLight: primaryLight ?? this.primaryLight,
      accent: accent ?? this.accent,
    );
  }

  @override
  BloodlinkColors lerp(ThemeExtension<BloodlinkColors>? other, double t) {
    if (other is! BloodlinkColors) return this;
    return BloodlinkColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      critical: Color.lerp(critical, other.critical, t)!,
      info: Color.lerp(info, other.info, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
    );
  }
}
