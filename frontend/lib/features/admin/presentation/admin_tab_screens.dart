import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:frontend/core/providers/auth_controller.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/widgets/widgets.dart';
import 'package:frontend/features/admin/presentation/admin_staff_links.dart';
import 'package:frontend/data/mock/mock_data.dart';
import 'package:frontend/data/repositories/request_repository.dart';
import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/data/repositories/inventory_repository.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _pending = 0;
  int _stock = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final branchId = context.read<AuthController>().user?.branchId;
    final requestRepo = context.read<RequestRepository>();
    final inventoryRepo = context.read<InventoryRepository>();
    final pending =
        await requestRepo.getRequests(status: RequestStatus.pending);
    final stock =
        await inventoryRepo.countAvailable(branchId: branchId);
    if (!mounted) return;
    setState(() {
      _pending = pending.length;
      _stock = stock;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthController>().user;
    if (_loading) return const Center(child: CircularProgressIndicator());

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Admin overview',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        Text(
          '${user?.fullName} · ${MockData.branches.firstWhere((b) => b.id == user?.branchId).name}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.55),
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Inherits all Staff operations via the Operations tab.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SummaryStatCard(
                label: 'Pending requests',
                value: '$_pending',
                icon: Icons.pending_actions_outlined,
                onTap: () => openAdminStaffFlow(context, AppRoutes.staffRequests),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SummaryStatCard(
                label: 'Units in stock',
                value: '$_stock',
                icon: Icons.inventory_2_outlined,
                onTap: () => openAdminStaffFlow(context, AppRoutes.staffInventory),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
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
            for (final link in adminStaffLinks.take(3))
              ActionChip(
                avatar: Icon(link.icon, size: 18),
                label: Text(link.title),
                onPressed: () => openAdminStaffFlow(context, link.route),
              ),
          ],
        ),
      ],
    );
  }
}

class AdminReportsScreen extends StatelessWidget {
  const AdminReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Reports',
      subtitle: 'Phase 5 — reports list and generate',
      icon: Icons.assessment_outlined,
      wrapScaffold: false,
    );
  }
}

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Settings',
      subtitle: 'Phase 5 — branch settings and staff management',
      icon: Icons.settings_outlined,
      wrapScaffold: false,
    );
  }
}
