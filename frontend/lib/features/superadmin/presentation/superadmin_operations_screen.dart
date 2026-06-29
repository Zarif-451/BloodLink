import 'package:flutter/material.dart';

import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/core/widgets/role_gate.dart';
import 'package:frontend/features/superadmin/presentation/superadmin_flow_links.dart';

class SuperadminOperationsScreen extends StatelessWidget {
  const SuperadminOperationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sections =
        superadminFlowLinks.map((l) => l.section).toSet().toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'System operations',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'System screens live in the drawer. Fulfillment reuses Staff flows.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
              ),
        ),
        const SizedBox(height: 16),
        for (final section in sections) ...[
          Text(
            section!,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          for (final link in superadminFlowLinks.where((l) => l.section == section))
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Icon(link.icon),
                title: Text(link.title),
                subtitle: link.subtitle != null ? Text(link.subtitle!) : null,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => openSuperadminFlow(context, link),
              ),
            ),
          const SizedBox(height: 8),
        ],
        RoleGate(
          allowedRoles: const {UserRole.superadmin},
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Donor registration stays branch-staff managed — no superadmin donor login.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.55),
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
