import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/core/providers/auth_controller.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/features/superadmin/presentation/superadmin_utils.dart';
import 'package:frontend/core/widgets/widgets.dart';
import 'package:frontend/data/models/blood_request.dart';
import 'package:frontend/data/models/transport.dart';
import 'package:frontend/data/repositories/request_repository.dart';
import 'package:frontend/data/repositories/transport_repository.dart';

class RequestDetailScreen extends StatefulWidget {
  const RequestDetailScreen({super.key, required this.requestId});

  final int requestId;

  @override
  State<RequestDetailScreen> createState() => _RequestDetailScreenState();
}

class _RequestDetailScreenState extends State<RequestDetailScreen> {
  BloodRequest? _request;
  Requester? _requester;
  List<Allocation> _allocations = [];
  Transport? _transport;
  bool _loading = true;
  bool _acting = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final requestRepo = context.read<RequestRepository>();
    final allocationRepo = context.read<AllocationRepository>();
    final transportRepo = context.read<TransportRepository>();

    final request = await requestRepo.getRequest(widget.requestId);
    Requester? requester;
    List<Allocation> allocations = [];
    Transport? transport;

    if (request != null) {
      requester = await requestRepo.getRequester(request.requesterId);
      allocations =
          await allocationRepo.getAllocationsForRequest(request.id);
      if (allocations.isNotEmpty && allocations.first.transportId > 0) {
        transport =
            await transportRepo.getTransport(allocations.first.transportId);
      }
    }

    if (!mounted) return;
    setState(() {
      _request = request;
      _requester = requester;
      _allocations = allocations;
      _transport = transport;
      _loading = false;
    });
  }

  Future<void> _approve() async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Approve request',
      message: 'Approve BL-${widget.requestId} and allow allocation?',
      confirmLabel: 'Approve',
    );
    if (confirmed != true || !mounted) return;

    setState(() => _acting = true);
    try {
      await context.read<RequestRepository>().approveRequest(widget.requestId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request approved')),
      );
      await _load();
    } finally {
      if (mounted) setState(() => _acting = false);
    }
  }

  Future<void> _reject() async {
    final reasonController = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject request'),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(
            labelText: 'Reason',
            hintText: 'e.g. Insufficient documentation',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final text = reasonController.text.trim();
              if (text.isEmpty) return;
              Navigator.pop(context, text);
            },
            child: const Text('Reject'),
          ),
        ],
      ),
    );
    reasonController.dispose();
    if (reason == null || !mounted) return;

    setState(() => _acting = true);
    try {
      await context.read<RequestRepository>().rejectRequest(
            widget.requestId,
            reason: reason,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request rejected')),
      );
      await _load();
    } finally {
      if (mounted) setState(() => _acting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Request detail')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final request = _request;
    if (request == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Request detail')),
        body: const Center(child: Text('Request not found')),
      );
    }

    final requester = _requester;
    final isPending = request.status == RequestStatus.pending;
    final isApproved = request.status == RequestStatus.approved;
    final canAllocate = isApproved;

    return Scaffold(
      appBar: AppBar(title: Text('BL-${request.id}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              UrgencyBadge(urgency: request.urgency.label),
              const SizedBox(width: 8),
              StatusPill(label: request.status.label, tone: request.status.tone),
            ],
          ),
          const SizedBox(height: 16),
          _Section(
            title: 'Blood needed',
            children: [
              Row(
                children: [
                  BloodGroupChip(group: request.bloodGroup.label),
                  const SizedBox(width: 12),
                  Text('${request.quantity} unit(s)'),
                ],
              ),
              Text(
                'Requested ${DateFormat.yMMMd().add_jm().format(request.requestDate)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          if (requester != null)
            _Section(
              title: 'Requester',
              children: [
                Text(requester.name, style: Theme.of(context).textTheme.titleSmall),
                if (requester.city.isNotEmpty) Text(requester.city),
                if (requester.phones.isNotEmpty)
                  Text(requester.phones.join(', ')),
              ],
            ),
          if (request.rejectReason != null)
            _Section(
              title: 'Rejection reason',
              children: [Text(request.rejectReason!)],
            ),
          if (_allocations.isNotEmpty)
            _Section(
              title: 'Allocation',
              children: [
                for (final a in _allocations)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('${a.allocatedQuantity} unit(s) allocated'),
                    subtitle: Text(
                      DateFormat.yMMMd().format(a.allocationDate),
                    ),
                  ),
              ],
            ),
          if (_transport != null)
            _Section(
              title: 'Transport',
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(_transport!.destinationName),
                  subtitle: Text(_transport!.status.label),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(
                    AppRoutes.staffTransportDetail(_transport!.id),
                  ),
                ),
              ],
            ),
        ],
      ),
      bottomNavigationBar: isPending || canAllocate
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isPending) ...[
                      FilledButton(
                        onPressed: _acting ? null : _approve,
                        child: _acting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Approve'),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: _acting ? null : _reject,
                        child: const Text('Reject'),
                      ),
                    ],
                    if (canAllocate)
                      FilledButton.icon(
                        onPressed: () => _openAllocate(context, request.id),
                        icon: const Icon(Icons.bloodtype),
                        label: const Text('Allocate blood'),
                      ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Future<void> _openAllocate(BuildContext context, int requestId) async {
    final role = context.read<AuthController>().user?.role;
    if (role == UserRole.superadmin) {
      final branchId = await showFulfillingBranchPicker(context);
      if (branchId == null || !context.mounted) return;
      context.push(AppRoutes.staffAllocate(requestId, branchId: branchId));
    } else {
      context.push(AppRoutes.staffAllocate(requestId));
    }
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}
