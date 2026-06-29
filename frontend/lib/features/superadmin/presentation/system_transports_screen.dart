import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/widgets/widgets.dart';
import 'package:frontend/data/mock/mock_data.dart';
import 'package:frontend/data/models/transport.dart';
import 'package:frontend/data/repositories/transport_repository.dart';

class SystemTransportsScreen extends StatefulWidget {
  const SystemTransportsScreen({super.key});

  @override
  State<SystemTransportsScreen> createState() => _SystemTransportsScreenState();
}

class _SystemTransportsScreenState extends State<SystemTransportsScreen> {
  List<Transport> _transports = [];
  bool _loading = true;
  TransportStatus? _statusFilter;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final list = await context.read<TransportRepository>().getTransports(
          status: _statusFilter,
        );
    if (!mounted) return;
    setState(() {
      _transports = list;
      _loading = false;
    });
  }

  String _branchName(int id) =>
      MockData.branches.firstWhere((b) => b.id == id).name;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'All branches · read-only system view',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(
            children: [
              FilterChip(
                label: const Text('All'),
                selected: _statusFilter == null,
                onSelected: (_) {
                  setState(() => _statusFilter = null);
                  _load();
                },
              ),
              const SizedBox(width: 8),
              for (final s in TransportStatus.values)
                if (s != TransportStatus.cancelled)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(s.label),
                      selected: _statusFilter == s,
                      onSelected: (_) {
                        setState(() => _statusFilter = s);
                        _load();
                      },
                    ),
                  ),
            ],
          ),
        ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _transports.isEmpty
                  ? const EmptyState(
                      message: 'No transports',
                      icon: Icons.local_shipping_outlined,
                    )
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _transports.length,
                        itemBuilder: (context, index) {
                          final t = _transports[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: ListTile(
                              title: Text(t.destinationName),
                              subtitle: Text(
                                'From ${_branchName(t.sourceBranchId)}',
                              ),
                              trailing: StatusPill(
                                label: t.status.label,
                                tone: t.status.tone,
                              ),
                              onTap: () => context.push(
                                AppRoutes.staffTransportDetail(t.id),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
        ),
      ],
    );
  }
}
