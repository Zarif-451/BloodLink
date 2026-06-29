import 'package:flutter/material.dart';

import '../theme/bloodlink_colors.dart';

class UrgencyBadge extends StatelessWidget {
  const UrgencyBadge({super.key, required this.urgency});

  final String urgency;

  @override
  Widget build(BuildContext context) {
    final ext = BloodlinkColors.of(context);
    final scheme = Theme.of(context).colorScheme;
    final (color, bg) = switch (urgency.toLowerCase()) {
      'critical' => (ext.critical, ext.critical.withValues(alpha: 0.12)),
      'urgent' => (const Color(0xFFE65100), ext.warning.withValues(alpha: 0.2)),
      _ => (
          scheme.onSurface.withValues(alpha: 0.7),
          scheme.onSurface.withValues(alpha: 0.08),
        ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        urgency,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
