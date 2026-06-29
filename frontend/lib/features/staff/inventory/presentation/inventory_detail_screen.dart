import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/widgets/blood_group_chip.dart';
import 'package:frontend/core/widgets/confirm_dialog.dart';
import 'package:frontend/core/widgets/expiry_indicator.dart';
import 'package:frontend/core/widgets/status_pill.dart';
import 'package:frontend/data/mock/mock_data.dart';
import 'package:frontend/data/models/inventory_unit.dart';
import 'package:frontend/data/repositories/inventory_repository.dart';

class InventoryDetailScreen extends StatefulWidget {
  const InventoryDetailScreen({super.key, required this.inventoryId});

  final int inventoryId;

  @override
  State<InventoryDetailScreen> createState() => _InventoryDetailScreenState();
}

class _InventoryDetailScreenState extends State<InventoryDetailScreen> {
  InventoryUnit? _unit;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final unit =
        await context.read<InventoryRepository>().getUnit(widget.inventoryId);
    if (!mounted) return;
    if (unit == null) {
      context.pop();
      return;
    }
    setState(() {
      _unit = unit;
      _loading = false;
    });
  }

  Future<void> _updateStatus(InventoryStatus status) async {
    if (_unit == null) return;
    final confirmed = await showConfirmDialog(
      context,
      title: 'Update status',
      message: 'Change unit status to ${status.label}?',
      confirmLabel: 'Update',
    );
    if (confirmed != true || !mounted) return;

    final updated = _unit!.copyWith(status: status);
    await context.read<InventoryRepository>().updateUnit(updated);
    if (!mounted) return;
    setState(() => _unit = updated);
  }

  void _showStatusSheet() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final status in InventoryStatus.values)
              ListTile(
                title: Text(status.label),
                onTap: () {
                  Navigator.pop(context);
                  _updateStatus(status);
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _unit == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Inventory unit')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final unit = _unit!;
    final branch =
        MockData.branches.firstWhere((b) => b.id == unit.branchId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Unit ${unit.unitNumber}'),
        actions: [BloodGroupChip(group: unit.bloodGroup.label)],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          StatusPill(label: unit.status.label, tone: unit.status.tone),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Quantity'),
            subtitle: Text('${unit.quantity}'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Collection date'),
            subtitle: Text(DateFormat.yMMMd().format(unit.collectionDate)),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Expiry date'),
            subtitle: Text(DateFormat.yMMMd().format(unit.expiryDate)),
          ),
          ExpiryIndicator(expiryDate: unit.expiryDate),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Branch'),
            subtitle: Text(branch.name),
          ),
          if (unit.sourceDonationId != null) ...[
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => context.push(
                AppRoutes.staffDonationDetail(unit.sourceDonationId!),
              ),
              child: Text('View source donation #${unit.sourceDonationId}'),
            ),
          ],
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: _showStatusSheet,
            child: const Text('Update status'),
          ),
        ],
      ),
    );
  }
}
