import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/widgets/widgets.dart';
import 'package:frontend/data/mock/mock_data.dart';
import 'package:frontend/data/models/blood_request.dart';
import 'package:frontend/data/models/payment.dart';
import 'package:frontend/data/models/public_request_submission.dart';
import 'package:frontend/data/repositories/payment_repository.dart';
import 'package:frontend/data/repositories/request_repository.dart';
import 'package:frontend/features/public/presentation/request_timeline.dart';

class RequestStatusScreen extends StatefulWidget {
  const RequestStatusScreen({
    super.key,
    required this.requestId,
  });

  final int requestId;

  @override
  State<RequestStatusScreen> createState() => _RequestStatusScreenState();
}

class _RequestStatusScreenState extends State<RequestStatusScreen> {
  BloodRequest? _request;
  Payment? _payment;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final requestRepo = context.read<RequestRepository>();
    final paymentRepo = context.read<PaymentRepository>();

    final request = await requestRepo.getRequest(widget.requestId);
    Payment? payment;
    if (request != null) {
      payment = await paymentRepo.getPaymentForRequest(request.id);
    }

    if (!mounted) return;
    setState(() {
      _request = request;
      _payment = payment;
      _loading = false;
    });
  }

  Future<void> _callBranch() async {
    final uri = Uri.parse('tel:${AppRoutes.staffBranchHotline}');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Request status')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_request == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Request status')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.search_off_outlined, size: 48),
                const SizedBox(height: 16),
                const Text('Request not found'),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => context.go(AppRoutes.publicTrack),
                  child: const Text('Track another request'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final request = _request!;
    final branch = MockData.branches.firstWhere(
      (b) => b.id == MockData.dhakaBranchId,
    );
    final displayId = PublicRequestId.format(request.id);

    return Scaffold(
      appBar: AppBar(
        title: Text('Request $displayId'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.publicTrack);
            }
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                UrgencyBadge(urgency: request.urgency.label),
                StatusPill(
                  label: request.status.label,
                  tone: request.status.tone,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                BloodGroupChip(group: request.bloodGroup.label),
                const SizedBox(width: 12),
                Text('${request.quantity} unit(s)'),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Submitted: ${DateFormat.yMMMd().add_jm().format(request.requestDate)}',
            ),
            if (request.requesterName != null)
              Text('Requester: ${request.requesterName}'),
            const SizedBox(height: 24),
            Text(
              'Status timeline',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            TimelineStepper(steps: buildRequestTimeline(request.status)),
            const SizedBox(height: 24),
            Text(
              'Contact blood bank',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Text(branch.name),
            OutlinedButton.icon(
              onPressed: _callBranch,
              icon: const Icon(Icons.phone_outlined),
              label: Text('Call ${branch.phones.first}'),
            ),
            if (_payment != null) ...[
              const SizedBox(height: 24),
              Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: ListTile(
                  leading: const Icon(Icons.payment_outlined),
                  title: const Text('Payment required'),
                  subtitle: Text(
                    '৳${_payment!.amount.toStringAsFixed(0)} — ${_payment!.reason ?? 'Fee due'}',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(
                    AppRoutes.publicPayment(_payment!.id),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
