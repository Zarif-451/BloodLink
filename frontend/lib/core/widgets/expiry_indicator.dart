import 'package:flutter/material.dart';

import '../constants/strings.dart';
import '../theme/bloodlink_colors.dart';

class ExpiryIndicator extends StatelessWidget {
  const ExpiryIndicator({super.key, required this.expiryDate});

  final DateTime expiryDate;

  @override
  Widget build(BuildContext context) {
    final ext = BloodlinkColors.of(context);
    final days = expiryDate.difference(DateTime.now()).inDays;
    final (color, label) = switch (days) {
      < 0 => (ext.critical, 'Expired'),
      <= AppStrings.nearExpiryDays => (ext.warning, '$days d left'),
      _ => (ext.success, '$days d left'),
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.schedule, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: color),
        ),
      ],
    );
  }
}
