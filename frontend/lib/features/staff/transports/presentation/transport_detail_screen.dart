import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/core/widgets/confirm_dialog.dart';
import 'package:frontend/core/widgets/status_pill.dart';
import 'package:frontend/data/mock/mock_data.dart';
import 'package:frontend/data/models/transport.dart';
import 'package:frontend/data/repositories/transport_repository.dart';

class TransportDetailScreen extends StatefulWidget {
  const TransportDetailScreen({super.key, required this.transportId});

  final int transportId;

  @override
  State<TransportDetailScreen> createState() => _TransportDetailScreenState();
}

class _TransportDetailScreenState extends State<TransportDetailScreen> {
  Transport? _transport;
  Allocation? _allocation;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final transportRepo = context.read<TransportRepository>();
    final transport = await transportRepo.getTransport(widget.transportId);
    Allocation? allocation;
    if (transport != null) {
      for (final a in MockData.allocations) {
        if (a.transportId == transport.id) {
          allocation = a;
          break;
        }
      }
    }
    if (!mounted) return;
    if (transport == null) {
      context.pop();
      return;
    }
    setState(() {
      _transport = transport;
      _allocation = allocation;
      _loading = false;
    });
  }

  Future<void> _markStatus(TransportStatus status) async {
    if (_transport == null) return;
    final confirmed = await showConfirmDialog(
      context,
      title: 'Update transport',
      message: 'Mark as ${status.label}?',
      confirmLabel: 'Update',
    );
    if (confirmed != true || !mounted) return;

    final now = DateTime.now();
    var updated = _transport!.copyWith(status: status);
    if (status == TransportStatus.dispatched ||
        status == TransportStatus.inTransit) {
      updated = updated.copyWith(dispatchedTime: now);
      if (status == TransportStatus.inTransit) {
        updated = updated.copyWith(status: TransportStatus.inTransit);
      }
    }
    if (status == TransportStatus.delivered) {
      updated = updated.copyWith(receivedTime: now);
    }

    await context.read<TransportRepository>().updateTransport(updated);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Transport ${status.label.toLowerCase()}')),
    );
    await _load();
  }

  String _branchName(int id) =>
      MockData.branches.firstWhere((b) => b.id == id).name;

  @override
  Widget build(BuildContext context) {
    if (_loading || _transport == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Transport')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final transport = _transport!;
    final canDispatch = transport.status == TransportStatus.pending;
    final canDeliver = transport.status == TransportStatus.inTransit ||
        transport.status == TransportStatus.dispatched;

    return Scaffold(
      appBar: AppBar(title: Text('Transport #${transport.id}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          StatusPill(
            label: transport.status.label,
            tone: transport.status.tone,
          ),
          const SizedBox(height: 16),
          _Row(label: 'From', value: _branchName(transport.sourceBranchId)),
          _Row(label: 'Destination', value: transport.destinationName),
          _Row(label: 'Type', value: transport.destinationType.name),
          if (transport.scheduledDate != null)
            _Row(
              label: 'Scheduled',
              value: DateFormat.yMMMd().format(transport.scheduledDate!),
            ),
          if (transport.dispatchedTime != null)
            _Row(
              label: 'Dispatched',
              value: DateFormat.yMMMd().add_jm().format(transport.dispatchedTime!),
            ),
          if (transport.receivedTime != null)
            _Row(
              label: 'Received',
              value: DateFormat.yMMMd().add_jm().format(transport.receivedTime!),
            ),
          if (_allocation != null) ...[
            const SizedBox(height: 16),
            Text(
              'Linked allocation',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text('Request BL-${_allocation!.requestId}'),
            Text('${_allocation!.allocatedQuantity} unit(s)'),
          ],
        ],
      ),
      bottomNavigationBar: canDispatch || canDeliver
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (canDispatch)
                      FilledButton(
                        onPressed: () => _markStatus(TransportStatus.inTransit),
                        child: const Text('Mark in transit'),
                      ),
                    if (canDeliver) ...[
                      const SizedBox(height: 8),
                      FilledButton(
                        onPressed: () => _markStatus(TransportStatus.delivered),
                        child: const Text('Mark delivered'),
                      ),
                    ],
                  ],
                ),
              ),
            )
          : null,
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
