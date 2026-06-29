import 'package:flutter/material.dart';

import '../constants/status_tone.dart';
import '../theme/bloodlink_colors.dart';

export '../constants/status_tone.dart';

class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.label,
    this.tone = StatusTone.neutral,
  });

  final String label;
  final StatusTone tone;

  @override
  Widget build(BuildContext context) {
    final ext = BloodlinkColors.of(context);
    final color = switch (tone) {
      StatusTone.success => ext.success,
      StatusTone.warning => ext.warning,
      StatusTone.critical => ext.critical,
      StatusTone.info => ext.info,
      StatusTone.neutral =>
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(color: color.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: color),
      ),
    );
  }
}
