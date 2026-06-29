import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/theme/bloodlink_colors.dart';
import 'package:frontend/core/widgets/widgets.dart';
import 'package:frontend/data/models/blood_request.dart';
import 'package:frontend/data/repositories/request_repository.dart';

class RequestsQueueScreen extends StatefulWidget {
  const RequestsQueueScreen({super.key});

  @override
  State<RequestsQueueScreen> createState() => _RequestsQueueScreenState();
}

class _RequestsQueueScreenState extends State<RequestsQueueScreen> {
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
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_hasCriticalPending)
            MaterialBanner(
              content: const Text('Critical requests pending review'),
              leading: Icon(
                Icons.priority_high,
                color: BloodlinkColors.of(context).critical,
              ),
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
      ),
    );
  }
}

class RequestQueueCard extends StatelessWidget {
  const RequestQueueCard({
    super.key,
    required this.request,
    required this.onTap,
  });

  final BloodRequest request;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = BloodlinkColors.of(context);
    final isPending = request.status == RequestStatus.pending;
    final isApproved = request.status == RequestStatus.approved;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isPending
            ? BorderSide(color: ext.critical.withValues(alpha: 0.5), width: 2)
            : BorderSide.none,
      ),
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
                  Text(
                    'BL-${request.id}',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const Spacer(),
                  UrgencyBadge(urgency: request.urgency.label),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                request.requesterName ?? 'Requester',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  BloodGroupChip(group: request.bloodGroup.label),
                  const SizedBox(width: 8),
                  Text(
                    '${request.quantity} unit${request.quantity == 1 ? '' : 's'}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurface.withValues(alpha: 0.6),
                        ),
                  ),
                  const Spacer(),
                  StatusPill(
                    label: request.status.label,
                    tone: request.status.tone,
                  ),
                ],
              ),
              if (isApproved) ...[
                const SizedBox(height: 8),
                Text(
                  'Ready to allocate',
                  style: TextStyle(
                    fontSize: 12,
                    color: ext.success,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              if (request.urgency == Urgency.critical && isPending) ...[
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: ext.critical.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.priority_high, size: 16, color: ext.critical),
                      const SizedBox(width: 4),
                      Text(
                        'Review within 30 minutes',
                        style: TextStyle(
                          fontSize: 12,
                          color: ext.critical,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 4),
              Text(
                DateFormat.yMMMd().add_jm().format(request.requestDate),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
