import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/theme/bloodlink_colors.dart';
import 'package:frontend/core/widgets/widgets.dart';
import 'package:frontend/data/models/blood_request.dart';
import 'package:frontend/data/repositories/request_repository.dart';
import 'package:frontend/features/staff/requests/presentation/requests_queue_screen.dart';

class SystemRequestsScreen extends StatefulWidget {
  const SystemRequestsScreen({super.key});

  @override
  State<SystemRequestsScreen> createState() => _SystemRequestsScreenState();
}

class _SystemRequestsScreenState extends State<SystemRequestsScreen> {
  List<BloodRequest> _requests = [];
  bool _loading = true;
  Urgency? _urgencyFilter;
  bool _pendingOnly = false;
  BloodGroup? _bloodGroupFilter;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final list = await context.read<RequestRepository>().getRequests(
          urgency: _urgencyFilter,
          bloodGroup: _bloodGroupFilter,
          openOnly: true,
          status: _pendingOnly ? RequestStatus.pending : null,
        );
    if (!mounted) return;
    setState(() {
      _requests = list;
      _loading = false;
    });
  }

  bool get _hasCriticalPending => _requests.any(
        (r) => r.urgency == Urgency.critical && r.status == RequestStatus.pending,
      );

  @override
  Widget build(BuildContext context) {
    final ext = BloodlinkColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Text(
            'All branches · allocate with branch picker',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        if (_hasCriticalPending)
          MaterialBanner(
            content: const Text('Critical requests pending review'),
            leading: Icon(Icons.priority_high, color: ext.critical),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _pendingOnly = true;
                    _urgencyFilter = Urgency.critical;
                  });
                  _load();
                },
                child: const Text('View'),
              ),
            ],
          ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(
            children: [
              FilterChip(
                label: const Text('All'),
                selected: _urgencyFilter == null,
                onSelected: (_) {
                  setState(() => _urgencyFilter = null);
                  _load();
                },
              ),
              const SizedBox(width: 8),
              for (final u in Urgency.values)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(u.label),
                    selected: _urgencyFilter == u,
                    onSelected: (_) {
                      setState(() => _urgencyFilter = u);
                      _load();
                    },
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
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
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: FilterChip(
            label: const Text('Pending review'),
            selected: _pendingOnly,
            onSelected: (v) {
              setState(() => _pendingOnly = v);
              _load();
            },
          ),
        ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _requests.isEmpty
                  ? const EmptyState(
                      message: 'No open requests',
                      icon: Icons.pending_actions_outlined,
                    )
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _requests.length,
                        itemBuilder: (context, index) {
                          return RequestQueueCard(
                            request: _requests[index],
                            onTap: () => context.push(
                              AppRoutes.staffRequestDetail(
                                _requests[index].id,
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
