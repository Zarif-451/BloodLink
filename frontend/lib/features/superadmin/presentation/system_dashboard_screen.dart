import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/theme/bloodlink_colors.dart';
import 'package:frontend/core/widgets/widgets.dart';
import 'package:frontend/data/mock/mock_data.dart';
import 'package:frontend/data/repositories/inventory_repository.dart';
import 'package:frontend/data/repositories/request_repository.dart';
import 'package:frontend/data/repositories/transport_repository.dart';
import 'package:frontend/features/superadmin/presentation/superadmin_flow_links.dart';

class SystemDashboardScreen extends StatefulWidget {
  const SystemDashboardScreen({super.key});

  @override
  State<SystemDashboardScreen> createState() => _SystemDashboardScreenState();
}

class _SystemDashboardScreenState extends State<SystemDashboardScreen> {
  int _branches = 0;
  int _openRequests = 0;
  int _criticalPending = 0;
  int _totalStock = 0;
  int _activeTransports = 0;
  final List<(String name, int stock)> _lowStockBranches = [];
  bool _loading = true;

  static const _lowStockThreshold = 5;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final requestRepo = context.read<RequestRepository>();
    final inventoryRepo = context.read<InventoryRepository>();
    final transportRepo = context.read<TransportRepository>();

    final open = await requestRepo.getRequests(openOnly: true);
    final critical = await requestRepo.getRequests(
      status: RequestStatus.pending,
      urgency: Urgency.critical,
    );
    final stock = await inventoryRepo.countAvailable();
    final lowStock = <(String, int)>[];
    for (final branch in MockData.branches) {
      final count = await inventoryRepo.countAvailable(branchId: branch.id);
      if (count < _lowStockThreshold) {
        lowStock.add((branch.name, count));
      }
    }
    final transports = await transportRepo.getTransports();
    final active = transports
        .where(
          (t) =>
              t.status == TransportStatus.inTransit ||
              t.status == TransportStatus.dispatched ||
              t.status == TransportStatus.pending,
        )
        .length;

    if (!mounted) return;
    setState(() {
      _branches = MockData.branches.length;
      _openRequests = open.length;
      _criticalPending = critical.length;
      _totalStock = stock;
      _activeTransports = active;
      _lowStockBranches
        ..clear()
        ..addAll(lowStock);
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    final ext = BloodlinkColors.of(context);

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'System overview',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          Text(
            'All branches · mock data',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.55),
                ),
          ),
          if (_criticalPending > 0) ...[
            const SizedBox(height: 12),
            MaterialBanner(
              content: Text('$_criticalPending critical request(s) pending'),
              leading: Icon(Icons.priority_high, color: ext.critical),
              actions: [
                TextButton(
                  onPressed: () => context.go(AppRoutes.superadminRequests),
                  child: const Text('View queue'),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SummaryStatCard(
                  label: 'Branches',
                  value: '$_branches',
                  icon: Icons.account_balance_outlined,
                  onTap: () => context.go(AppRoutes.superadminBranches),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SummaryStatCard(
                  label: 'Open requests',
                  value: '$_openRequests',
                  icon: Icons.pending_actions_outlined,
                  onTap: () => context.go(AppRoutes.superadminRequests),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: SummaryStatCard(
                  label: 'Total stock',
                  value: '$_totalStock',
                  icon: Icons.inventory_2_outlined,
                  onTap: () => context.go(AppRoutes.superadminInventory),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SummaryStatCard(
                  label: 'Active transports',
                  value: '$_activeTransports',
                  icon: Icons.local_shipping_outlined,
                  onTap: () => context.go(AppRoutes.superadminTransports),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_lowStockBranches.isNotEmpty) ...[
            Text(
              'Low stock by branch',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            for (final entry in _lowStockBranches)
              Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(entry.$1),
                  subtitle: Text('${entry.$2} units available'),
                  trailing: Icon(Icons.warning_amber_outlined, color: ext.warning),
                  onTap: () => context.go(AppRoutes.superadminInventory),
                ),
              ),
            const SizedBox(height: 8),
          ],
          Text(
            'Quick links',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                avatar: const Icon(Icons.hub_outlined, size: 18),
                label: const Text('Operations hub'),
                onPressed: () => context.go(AppRoutes.superadminOperations),
              ),
              for (final link in superadminFlowLinks.take(4))
                ActionChip(
                  avatar: Icon(link.icon, size: 18),
                  label: Text(link.title),
                  onPressed: () => openSuperadminFlow(context, link),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
