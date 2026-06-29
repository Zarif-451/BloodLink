import 'package:flutter/material.dart';

import '../widgets/preview_widgets.dart';

/// Staff dashboard mock — stats + quick actions.
class SampleDashboardPage extends StatelessWidget {
  const SampleDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good morning, Fatima',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          Text(
            'Dhaka Branch · Sunday, 7 Jun',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onSurface.withValues(alpha: 0.55),
                ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.35,
            children: const [
              SummaryStatCard(
                label: 'Pending requests',
                value: '4',
                icon: Icons.pending_actions_outlined,
              ),
              SummaryStatCard(
                label: 'Units in stock',
                value: '128',
                icon: Icons.inventory_2_outlined,
              ),
              SummaryStatCard(
                label: 'Donations today',
                value: '6',
                icon: Icons.volunteer_activism_outlined,
              ),
              SummaryStatCard(
                label: 'Expiring ≤7 days',
                value: '3',
                icon: Icons.schedule_outlined,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Quick actions',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _QuickAction(
                icon: Icons.person_add_outlined,
                label: 'Register donor',
                onTap: () {},
              ),
              _QuickAction(
                icon: Icons.bloodtype_outlined,
                label: 'Record donation',
                onTap: () {},
              ),
              _QuickAction(
                icon: Icons.local_shipping_outlined,
                label: 'Transport',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: scheme.primary.withValues(alpha: 0.12),
                child: Icon(Icons.warning_amber_rounded, color: scheme.primary),
              ),
              title: const Text('Low stock: O-'),
              subtitle: const Text('2 units · consider inter-branch allocation'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}
