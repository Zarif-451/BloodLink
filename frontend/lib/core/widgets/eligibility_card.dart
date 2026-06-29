import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/bloodlink_colors.dart';

class EligibilityCard extends StatelessWidget {
  const EligibilityCard({
    super.key,
    required this.isEligible,
    this.eligibleNextDate,
  });

  final bool isEligible;
  final DateTime? eligibleNextDate;

  @override
  Widget build(BuildContext context) {
    final ext = BloodlinkColors.of(context);
    final color = isEligible ? ext.success : ext.warning;
    final bg = color.withValues(alpha: 0.1);
    final title = isEligible ? 'Eligible to donate' : 'Not eligible yet';
    final subtitle = isEligible
        ? 'Donor can proceed with donation'
        : eligibleNextDate != null
            ? 'Eligible from ${DateFormat.yMMMd().format(eligibleNextDate!)}'
            : 'Waiting period not met';

    return Card(
      color: bg,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              isEligible ? Icons.check_circle_outline : Icons.hourglass_empty,
              color: color,
              size: 32,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.7),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
