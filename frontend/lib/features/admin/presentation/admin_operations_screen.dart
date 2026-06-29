import 'package:flutter/material.dart';

import 'package:frontend/core/widgets/role_gate.dart';
import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/features/admin/presentation/admin_staff_links.dart';

class AdminOperationsScreen extends StatelessWidget {
  const AdminOperationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = adminStaffLinks.map((l) => l.section).toSet().toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Branch operations',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'Same screens as Staff — no duplicate implementation.',
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
          for (final link in adminStaffLinks.where((l) => l.section == section))
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Icon(link.icon),
                title: Text(link.title),
                subtitle: link.subtitle != null ? Text(link.subtitle!) : null,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => openAdminStaffFlow(context, link.route),
              ),
            ),
          const SizedBox(height: 8),
        ],
        RoleGate(
          allowedRoles: const {UserRole.superadmin},
          fallback: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Cross-branch and system settings are available to Superadmin only.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.55),
                  ),
            ),
          ),
          child: const SizedBox.shrink(),
        ),
      ],
    );
  }
}
