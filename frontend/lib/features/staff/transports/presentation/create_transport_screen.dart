import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/core/providers/auth_controller.dart';
import 'package:frontend/data/mock/mock_data.dart';
import 'package:frontend/data/models/transport.dart';
import 'package:frontend/data/repositories/transport_repository.dart';

class CreateTransportScreen extends StatefulWidget {
  const CreateTransportScreen({super.key});

  @override
  State<CreateTransportScreen> createState() => _CreateTransportScreenState();
}

class _CreateTransportScreenState extends State<CreateTransportScreen> {
  int? _sourceBranchId;
  DestinationType _destinationType = DestinationType.branch;
  final _destinationController = TextEditingController();
  DateTime _scheduledDate = DateTime.now().add(const Duration(days: 1));
  bool _saving = false;

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final staffBranch = context.read<AuthController>().user?.branchId;
    _sourceBranchId ??= staffBranch;

    if (_sourceBranchId == null || _destinationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fill all required fields')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      final created = await context.read<TransportRepository>().createTransport(
            Transport(
              id: 0,
              sourceBranchId: _sourceBranchId!,
              destinationType: _destinationType,
              destinationName: _destinationController.text.trim(),
              status: TransportStatus.pending,
              scheduledDate: _scheduledDate,
            ),
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transport created')),
      );
      context.pop(created.id);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final staffBranch = context.read<AuthController>().user?.branchId;

    return Scaffold(
      appBar: AppBar(title: const Text('Create transport')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<int>(
            key: ValueKey(_sourceBranchId ?? staffBranch),
            initialValue: _sourceBranchId ?? staffBranch,
            decoration: const InputDecoration(labelText: 'Source branch'),
            items: [
              for (final b in MockData.branches)
                DropdownMenuItem(value: b.id, child: Text(b.name)),
            ],
            onChanged: (v) => setState(() => _sourceBranchId = v),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<DestinationType>(
            key: ValueKey(_destinationType),
            initialValue: _destinationType,
            decoration: const InputDecoration(labelText: 'Destination type'),
            items: const [
              DropdownMenuItem(
                value: DestinationType.branch,
                child: Text('Branch'),
              ),
              DropdownMenuItem(
                value: DestinationType.hospital,
                child: Text('Hospital'),
              ),
            ],
            onChanged: (v) {
              if (v != null) setState(() => _destinationType = v);
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _destinationController,
            decoration: const InputDecoration(
              labelText: 'Destination name',
              hintText: 'Hospital or branch name',
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Scheduled date'),
            subtitle: Text(DateFormat.yMMMd().format(_scheduledDate)),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _scheduledDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 60)),
              );
              if (picked != null) setState(() => _scheduledDate = picked);
            },
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Create transport'),
          ),
        ),
      ),
    );
  }
}
