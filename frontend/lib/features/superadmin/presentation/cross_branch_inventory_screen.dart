import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/theme/bloodlink_colors.dart';
import 'package:frontend/core/widgets/widgets.dart';
import 'package:frontend/data/mock/mock_data.dart';
import 'package:frontend/data/models/branch.dart';
import 'package:frontend/data/repositories/inventory_repository.dart';

const _lowStockThreshold = 5;

class CrossBranchInventoryScreen extends StatefulWidget {
  const CrossBranchInventoryScreen({super.key});

  @override
  State<CrossBranchInventoryScreen> createState() =>
      _CrossBranchInventoryScreenState();
}

class _CrossBranchInventoryScreenState
    extends State<CrossBranchInventoryScreen> {
  final Map<int, Map<BloodGroup, int>> _byBranch = {};
  final Map<int, int> _totals = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final repo = context.read<InventoryRepository>();
    final branches = MockData.branches;
    final byBranch = <int, Map<BloodGroup, int>>{};
    final totals = <int, int>{};

    for (final branch in branches) {
      final counts = await repo.countByBloodGroup(
        branchId: branch.id,
        status: InventoryStatus.available,
      );
      byBranch[branch.id] = counts;
      totals[branch.id] = counts.values.fold(0, (a, b) => a + b);
    }

    if (!mounted) return;
    setState(() {
      _byBranch
        ..clear()
        ..addAll(byBranch);
      _totals
        ..clear()
        ..addAll(totals);
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    final ext = BloodlinkColors.of(context);
    final lowStockBranches = MockData.branches
        .where((b) => (_totals[b.id] ?? 0) < _lowStockThreshold)
        .toList();

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (lowStockBranches.isNotEmpty) ...[
            MaterialBanner(
              content: Text(
                '${lowStockBranches.length} branch(es) below $_lowStockThreshold units',
              ),
              leading: Icon(Icons.warning_amber_outlined, color: ext.warning),
              actions: [
                TextButton(
                  onPressed: () =>
                      ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
                  child: const Text('Dismiss'),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          Text(
            'Stock by branch',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          for (final branch in MockData.branches)
            _BranchStockCard(
              branch: branch,
              total: _totals[branch.id] ?? 0,
              counts: _byBranch[branch.id] ?? {},
              isLow: (_totals[branch.id] ?? 0) < _lowStockThreshold,
              onTap: () => context.push(
                AppRoutes.superadminBranchInventory(branch.id),
              ),
            ),
        ],
      ),
    );
  }
}

class _BranchStockCard extends StatelessWidget {
  const _BranchStockCard({
    required this.branch,
    required this.total,
    required this.counts,
    required this.isLow,
    required this.onTap,
  });

  final Branch branch;
  final int total;
  final Map<BloodGroup, int> counts;
  final bool isLow;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = BloodlinkColors.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      branch.name,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  if (isLow)
                    StatusPill(label: 'Low stock', tone: StatusTone.warning),
                  const SizedBox(width: 8),
                  Text(
                    '$total units',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: isLow ? ext.warning : null,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
              if (counts.isNotEmpty) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final entry in counts.entries)
                      if (entry.value > 0)
                        BloodGroupChip(group: entry.key.label),
                  ],
                ),
              ] else
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'No available units',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
