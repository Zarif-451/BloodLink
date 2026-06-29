import 'package:flutter/material.dart';

import 'package:frontend/core/widgets/placeholder_screen.dart';

class StaffDonorsScreen extends StatelessWidget {
  const StaffDonorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Donors',
      subtitle: 'Phase 2 — donors list, register, edit',
      icon: Icons.people_outline,
      wrapScaffold: false,
    );
  }
}

class StaffInventoryScreen extends StatelessWidget {
  const StaffInventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Inventory',
      subtitle: 'Phase 2 — blood units list and detail',
      icon: Icons.inventory_2_outlined,
      wrapScaffold: false,
    );
  }
}

class StaffRequestsScreen extends StatelessWidget {
  const StaffRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Requests',
      subtitle: 'Phase 4 — request queue and approve/reject',
      icon: Icons.pending_actions_outlined,
      wrapScaffold: false,
    );
  }
}
