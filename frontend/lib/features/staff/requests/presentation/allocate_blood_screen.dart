import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/core/providers/auth_controller.dart';
import 'package:frontend/core/widgets/widgets.dart';
import 'package:frontend/data/mock/mock_data.dart';
import 'package:frontend/data/models/blood_request.dart';
import 'package:frontend/data/models/inventory_unit.dart';
import 'package:frontend/data/models/transport.dart';
import 'package:frontend/data/repositories/fulfillment_repository.dart';
import 'package:frontend/data/repositories/inventory_repository.dart';
import 'package:frontend/data/repositories/request_repository.dart';

class AllocateBloodScreen extends StatefulWidget {
  const AllocateBloodScreen({
    super.key,
    required this.requestId,
    this.fulfillingBranchId,
  });

  final int requestId;
  final int? fulfillingBranchId;

  @override
  State<AllocateBloodScreen> createState() => _AllocateBloodScreenState();
}

class _AllocateBloodScreenState extends State<AllocateBloodScreen> {
  static const _stepLabels = [
    'Request',
    'Local stock',
    'Other branch',
    'Transport',
    'Confirm',
  ];

  BloodRequest? _request;
  Requester? _requester;
  List<InventoryUnit> _localUnits = [];
  List<InventoryUnit> _remoteUnits = [];
  final Set<int> _selectedUnitIds = {};
  int? _staffBranchId;
  int? _sourceBranchId;
  DateTime _scheduledDate = DateTime.now().add(const Duration(days: 1));
  bool _loading = true;
  bool _submitting = false;
  int _step = 0;

  int get _needed => _request?.quantity ?? 0;
  int get _selectedCount => _selectedUnitIds.length;
  bool get _needsMoreUnits => _selectedCount < _needed;
  bool get _needsTransport {
    if (_staffBranchId == null) return false;
    for (final id in _selectedUnitIds) {
      final unit = _allUnits.firstWhere((u) => u.id == id);
      if (unit.branchId != _staffBranchId) return true;
    }
    return false;
  }

  List<InventoryUnit> get _allUnits => [..._localUnits, ..._remoteUnits];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final requestRepo = context.read<RequestRepository>();
    final inventoryRepo = context.read<InventoryRepository>();
    _staffBranchId = widget.fulfillingBranchId ??
        context.read<AuthController>().user?.branchId;

    final request = await requestRepo.getRequest(widget.requestId);
    Requester? requester;
    List<InventoryUnit> local = [];

    if (request != null) {
      requester = await requestRepo.getRequester(request.requesterId);
      local = await inventoryRepo.getUnits(
        branchId: _staffBranchId,
        bloodGroup: request.bloodGroup,
        status: InventoryStatus.available,
      );
    }

    if (!mounted) return;
    if (request == null || request.status != RequestStatus.approved) {
      context.pop();
      return;
    }

    setState(() {
      _request = request;
      _requester = requester;
      _localUnits = local;
      _loading = false;
    });
  }

  Future<void> _loadRemoteUnits(int branchId) async {
    final inventoryRepo = context.read<InventoryRepository>();
    final units = await inventoryRepo.getUnits(
      branchId: branchId,
      bloodGroup: _request!.bloodGroup,
      status: InventoryStatus.available,
    );
    if (!mounted) return;
    setState(() {
      _sourceBranchId = branchId;
      _remoteUnits = units;
    });
  }

  Future<Map<int, int>> _branchStockCounts() async {
    final fulfillment = context.read<FulfillmentRepository>();
    final counts = <int, int>{};
    for (final branch in MockData.branches) {
      if (branch.id == _staffBranchId) continue;
      final n = await fulfillment.countAvailableUnits(
        branchId: branch.id,
        bloodGroup: _request!.bloodGroup,
      );
      if (n > 0) counts[branch.id] = n;
    }
    return counts;
  }

  void _toggleUnit(InventoryUnit unit) {
    setState(() {
      if (_selectedUnitIds.contains(unit.id)) {
        _selectedUnitIds.remove(unit.id);
      } else if (_selectedCount < _needed) {
        _selectedUnitIds.add(unit.id);
      }
    });
  }

  bool _canContinue() {
    return switch (_step) {
      0 => true,
      1 => _selectedCount > 0 || _localUnits.isEmpty,
      2 => _selectedCount == _needed,
      3 => !_needsTransport || _sourceBranchId != null,
      4 => _selectedCount == _needed,
      _ => false,
    };
  }

  void _next() {
    if (_step == 1 && !_needsMoreUnits) {
      setState(() => _step = 4);
      return;
    }
    if (_step == 1 && _needsMoreUnits) {
      setState(() => _step = 2);
      return;
    }
    if (_step == 2 && !_needsTransport) {
      setState(() => _step = 4);
      return;
    }
    if (_step == 2 && _needsTransport) {
      setState(() => _step = 3);
      return;
    }
    if (_step < 4) {
      setState(() => _step++);
    } else {
      _submit();
    }
  }

  void _back() {
    if (_step == 4 && !_needsMoreUnits) {
      setState(() => _step = 1);
      return;
    }
    if (_step == 4 && !_needsTransport) {
      setState(() => _step = 2);
      return;
    }
    if (_step > 0) setState(() => _step--);
  }

  Future<void> _submit() async {
    if (_request == null || _staffBranchId == null) return;
    if (_selectedCount != _needed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Select exactly $_needed unit(s)')),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      Transport? transport;
      if (_needsTransport && _sourceBranchId != null) {
        final destBranch = MockData.branches
            .firstWhere((b) => b.id == _staffBranchId);
        transport = Transport(
          id: 0,
          sourceBranchId: _sourceBranchId!,
          destinationType: DestinationType.branch,
          destinationName: destBranch.name,
          status: TransportStatus.pending,
          scheduledDate: _scheduledDate,
        );
      }

      await context.read<FulfillmentRepository>().fulfillRequest(
            FulfillmentSubmission(
              requestId: _request!.id,
              inventoryUnitIds: _selectedUnitIds.toList(),
              fulfillingBranchId: _staffBranchId!,
              transport: transport,
            ),
          );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Blood allocated successfully')),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _request == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Allocate blood')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final request = _request!;
    final visibleStep = _step <= 4 ? _step : 4;

    return Scaffold(
      appBar: AppBar(title: Text('Allocate · BL-${request.id}')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(
              'Step ${visibleStep + 1} of 5 · ${_stepLabels[visibleStep]}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          LinearProgressIndicator(value: (visibleStep + 1) / 5),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_step == 0) _buildSummary(request),
                if (_step == 1) _buildUnitPicker(_localUnits, 'Local inventory'),
                if (_step == 2) _buildInterBranch(),
                if (_step == 3) _buildTransportStep(),
                if (_step == 4) _buildReview(request),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (_step > 0)
                OutlinedButton(onPressed: _submitting ? null : _back, child: const Text('Back')),
              const Spacer(),
              FilledButton(
                onPressed: _submitting || !_canContinue() ? null : _next,
                child: _submitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_step == 4 ? 'Confirm allocation' : 'Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummary(BloodRequest request) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          request.requesterName ?? 'Requester',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            BloodGroupChip(group: request.bloodGroup.label),
            const SizedBox(width: 8),
            UrgencyBadge(urgency: request.urgency.label),
          ],
        ),
        const SizedBox(height: 8),
        Text('${request.quantity} unit(s) required'),
        if (_requester != null && _requester!.city.isNotEmpty)
          Text(_requester!.city),
      ],
    );
  }

  Widget _buildUnitPicker(List<InventoryUnit> units, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        Text(
          'Selected $_selectedCount of $_needed',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        if (units.isEmpty)
          const EmptyState(
            message: 'No matching units available',
            icon: Icons.inventory_2_outlined,
          )
        else
          for (final unit in units)
            CheckboxListTile(
              value: _selectedUnitIds.contains(unit.id),
              onChanged: (_) => _toggleUnit(unit),
              title: Text(unit.unitNumber),
              subtitle: Text(
                'Expires ${DateFormat.yMMMd().format(unit.expiryDate)}',
              ),
              secondary: BloodGroupChip(group: unit.bloodGroup.label),
            ),
      ],
    );
  }

  Widget _buildInterBranch() {
    return FutureBuilder<Map<int, int>>(
      future: _branchStockCounts(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final counts = snapshot.data!;
        if (counts.isEmpty) {
          return const EmptyState(
            message: 'No other branches have matching stock',
            icon: Icons.store_outlined,
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Local stock covers $_selectedCount of $_needed. Pick another branch.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            for (final entry in counts.entries)
              ListTile(
                title: Text(
                  MockData.branches.firstWhere((b) => b.id == entry.key).name,
                ),
                subtitle: Text('${entry.value} unit(s) available'),
                trailing: _sourceBranchId == entry.key
                    ? const Icon(Icons.check_circle)
                    : null,
                onTap: () => _loadRemoteUnits(entry.key),
              ),
            if (_remoteUnits.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildUnitPicker(_remoteUnits, 'Units from selected branch'),
            ],
          ],
        );
      },
    );
  }

  Widget _buildTransportStep() {
    final sourceName = _sourceBranchId == null
        ? ''
        : MockData.branches.firstWhere((b) => b.id == _sourceBranchId).name;
    final destName = MockData.branches
        .firstWhere((b) => b.id == _staffBranchId)
        .name;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Inter-branch transport is required before allocation.'),
        const SizedBox(height: 12),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('From'),
          subtitle: Text(sourceName),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('To'),
          subtitle: Text(destName),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Scheduled'),
          subtitle: Text(DateFormat.yMMMd().format(_scheduledDate)),
          trailing: const Icon(Icons.calendar_today),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _scheduledDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 30)),
            );
            if (picked != null) setState(() => _scheduledDate = picked);
          },
        ),
      ],
    );
  }

  Widget _buildReview(BloodRequest request) {
    final selected = _allUnits.where((u) => _selectedUnitIds.contains(u.id));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('BL-${request.id} · ${request.bloodGroup.label}'),
        Text('${selected.length} unit(s)'),
        const SizedBox(height: 12),
        if (_needsTransport)
          Text(
            'Transport will be created from branch $_sourceBranchId',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        const SizedBox(height: 8),
        for (final unit in selected)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(unit.unitNumber),
            subtitle: Text(
              MockData.branches.firstWhere((b) => b.id == unit.branchId).name,
            ),
          ),
      ],
    );
  }
}
