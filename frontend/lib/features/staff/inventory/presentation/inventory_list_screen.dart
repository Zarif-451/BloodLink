import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/core/providers/auth_controller.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/widgets/widgets.dart';
import 'package:frontend/data/models/inventory_unit.dart';
import 'package:frontend/data/repositories/inventory_repository.dart';

class InventoryListScreen extends StatefulWidget {
  const InventoryListScreen({super.key, this.branchIdOverride});

  /// When set (e.g. superadmin drill-down), ignores auth branch.
  final int? branchIdOverride;

  @override
  State<InventoryListScreen> createState() => _InventoryListScreenState();
}

class _InventoryListScreenState extends State<InventoryListScreen> {
  List<InventoryUnit> _units = [];
  Map<BloodGroup, int> _summary = {};
  bool _loading = true;
  BloodGroup? _bloodGroupFilter;
  InventoryStatus? _statusFilter;
  bool _nearExpiryOnly = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final branchId =
        widget.branchIdOverride ?? context.read<AuthController>().user?.branchId;
    final repo = context.read<InventoryRepository>();
    final units = await repo.getUnits(
      branchId: branchId,
      bloodGroup: _bloodGroupFilter,
      status: _statusFilter,
      nearExpiryOnly: _nearExpiryOnly,
    );
    final summary = await repo.countByBloodGroup(
      branchId: branchId,
      status: InventoryStatus.available,
    );
    if (!mounted) return;
    setState(() {
      _units = units;
      _summary = summary;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final nearExpiryCount = _units
        .where((u) =>
            u.status == InventoryStatus.available &&
            u.expiryDate.difference(DateTime.now()).inDays <= 7)
        .length;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (nearExpiryCount > 0 && !_nearExpiryOnly)
            MaterialBanner(
              content: Text('$nearExpiryCount unit(s) expiring within 7 days'),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() => _nearExpiryOnly = true);
                    _load();
                  },
                  child: const Text('View'),
                ),
              ],
            ),
          if (_summary.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  for (final entry in _summary.entries)
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Chip(
                        label: Text('${entry.key.label}: ${entry.value}'),
                      ),
                    ),
                ],
              ),
            ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All groups'),
                  selected: _bloodGroupFilter == null,
                  onSelected: (_) {
                    setState(() => _bloodGroupFilter = null);
                    _load();
                  },
                ),
                const SizedBox(width: 8),
                for (final g in BloodGroup.values)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(g.label),
                      selected: _bloodGroupFilter == g,
                      onSelected: (_) {
                        setState(() => _bloodGroupFilter = g);
                        _load();
                      },
                    ),
                  ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Available'),
                  selected: _statusFilter == InventoryStatus.available,
                  onSelected: (_) {
                    setState(() {
                      _statusFilter = _statusFilter == InventoryStatus.available
                          ? null
                          : InventoryStatus.available;
                    });
                    _load();
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Near expiry'),
                  selected: _nearExpiryOnly,
                  onSelected: (_) {
                    setState(() => _nearExpiryOnly = !_nearExpiryOnly);
                    _load();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _units.isEmpty
                    ? const EmptyState(
                        message: 'No units in stock',
                        icon: Icons.inventory_2_outlined,
                      )
                    : RefreshIndicator(
                        onRefresh: _load,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _units.length,
                          itemBuilder: (context, index) {
                            final unit = _units[index];
                            return _InventoryRow(unit: unit);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

class _InventoryRow extends StatelessWidget {
  const _InventoryRow({required this.unit});

  final InventoryUnit unit;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: () => context.push(AppRoutes.staffInventoryDetail(unit.id)),
        title: Row(
          children: [
            Expanded(child: Text('Unit ${unit.unitNumber}')),
            BloodGroupChip(group: unit.bloodGroup.label),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Col: ${DateFormat.yMMMd().format(unit.collectionDate)} · '
              'Exp: ${DateFormat.yMMMd().format(unit.expiryDate)}',
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                StatusPill(label: unit.status.label, tone: unit.status.tone),
                const SizedBox(width: 8),
                ExpiryIndicator(expiryDate: unit.expiryDate),
              ],
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
