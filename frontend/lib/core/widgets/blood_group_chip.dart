import 'package:flutter/material.dart';

import '../theme/bloodlink_colors.dart';

class BloodGroupChip extends StatelessWidget {
  const BloodGroupChip({super.key, required this.group});

  final String group;

  @override
  Widget build(BuildContext context) {
    final ext = BloodlinkColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: ext.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ext.accent.withValues(alpha: 0.4)),
      ),
      child: Text(
        group,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          color: ext.accent,
        ),
      ),
    );
  }
}
