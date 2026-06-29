import 'package:flutter/material.dart';

import '../../core/theme/bloodlink_colors.dart';
import '../widgets/preview_widgets.dart';

/// Request queue mock — list cards with urgency + status.
class SampleRequestsPage extends StatelessWidget {
  const SampleRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _RequestCard(
          id: 'REQ-1042',
          hospital: 'Square Hospital',
          bloodGroup: 'A+',
          units: 2,
          urgency: 'Critical',
          status: 'Pending review',
          statusTone: StatusTone.warning,
        ),
        _RequestCard(
          id: 'REQ-1041',
          hospital: 'DMCH Emergency',
          bloodGroup: 'O-',
          units: 4,
          urgency: 'Urgent',
          status: 'Approved',
          statusTone: StatusTone.success,
        ),
        _RequestCard(
          id: 'REQ-1038',
          hospital: 'United Hospital',
          bloodGroup: 'B+',
          units: 1,
          urgency: 'Normal',
          status: 'Allocated',
          statusTone: StatusTone.info,
        ),
        _RequestCard(
          id: 'REQ-1035',
          hospital: 'Popular Diagnostic',
          bloodGroup: 'AB-',
          units: 2,
          urgency: 'Normal',
          status: 'Rejected',
          statusTone: StatusTone.critical,
        ),
      ],
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.id,
    required this.hospital,
    required this.bloodGroup,
    required this.units,
    required this.urgency,
    required this.status,
    required this.statusTone,
  });

  final String id;
  final String hospital;
  final String bloodGroup;
  final int units;
  final String urgency;
  final String status;
  final StatusTone statusTone;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = BloodlinkColors.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    id,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const Spacer(),
                  UrgencyBadge(urgency: urgency),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                hospital,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  BloodGroupChip(group: bloodGroup),
                  const SizedBox(width: 8),
                  Text(
                    '$units unit${units == 1 ? '' : 's'}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurface.withValues(alpha: 0.6),
                        ),
                  ),
                  const Spacer(),
                  StatusPill(label: status, tone: statusTone),
                ],
              ),
              if (urgency == 'Critical') ...[
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: ext.critical.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.priority_high, size: 16, color: ext.critical),
                      const SizedBox(width: 4),
                      Text(
                        'Review within 30 minutes',
                        style: TextStyle(
                          fontSize: 12,
                          color: ext.critical,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
