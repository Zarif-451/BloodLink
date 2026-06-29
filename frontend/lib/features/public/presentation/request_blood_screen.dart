import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/widgets/phone_number_field_list.dart';
import 'package:frontend/core/widgets/step_progress_bar.dart';
import 'package:frontend/data/models/public_request_submission.dart';
import 'package:frontend/data/repositories/request_repository.dart';

class RequestBloodScreen extends StatefulWidget {
  const RequestBloodScreen({super.key});

  @override
  State<RequestBloodScreen> createState() => _RequestBloodScreenState();
}

class _RequestBloodScreenState extends State<RequestBloodScreen> {
  int _step = 0;
  bool _submitting = false;

  RequesterType _type = RequesterType.hospital;
  final _nameController = TextEditingController();
  List<String> _phones = [''];
  final _streetController = TextEditingController();
  final _areaController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalController = TextEditingController();

  BloodGroup _bloodGroup = BloodGroup.oPositive;
  int _quantity = 1;
  Urgency _urgency = Urgency.normal;

  @override
  void dispose() {
    _nameController.dispose();
    _streetController.dispose();
    _areaController.dispose();
    _cityController.dispose();
    _postalController.dispose();
    super.dispose();
  }

  Future<void> _callBranch() async {
    final uri = Uri.parse('tel:${AppRoutes.staffBranchHotline}');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  bool _validateStep1() {
    if (_nameController.text.trim().isEmpty) {
      _showError('Organization / name is required');
      return false;
    }
    final phones = _phones.where((p) => p.trim().isNotEmpty).toList();
    if (phones.isEmpty) {
      _showError('At least one phone number is required');
      return false;
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _submit() async {
    if (_urgency == Urgency.critical) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm emergency request'),
          content: const Text(
            'Critical urgency is for life-threatening situations. Continue?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Confirm'),
            ),
          ],
        ),
      );
      if (ok != true) return;
    }

    if (!mounted) return;
    final requestRepo = context.read<RequestRepository>();
    setState(() => _submitting = true);
    final phones = _phones.where((p) => p.trim().isNotEmpty).toList();
    final submission = PublicRequestSubmission(
      requesterType: _type,
      name: _nameController.text.trim(),
      phones: phones,
      street: _streetController.text.trim(),
      area: _areaController.text.trim(),
      city: _cityController.text.trim(),
      postalCode: _postalController.text.trim(),
      bloodGroup: _bloodGroup,
      quantity: _quantity,
      urgency: _urgency,
    );

    final created = await requestRepo.createPublicRequest(submission);
    if (!mounted) return;
    setState(() => _submitting = false);
    context.go(
      '${AppRoutes.publicRequestSuccess}?id=${created.id}'
      '&group=${Uri.encodeComponent(created.bloodGroup.label)}'
      '&qty=${created.quantity}'
      '&urgency=${Uri.encodeComponent(created.urgency.label)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isCritical = _urgency == Urgency.critical && _step == 1;

    return Scaffold(
      appBar: AppBar(
        title: Text('Request blood · Step ${_step + 1}/2'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_step > 0) {
              setState(() => _step--);
            } else if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.login);
            }
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: StepProgressBar(
              labels: const ['Requester', 'Blood needed'],
              currentStep: _step,
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (_step == 0) ...[
                  Text('Who is requesting?',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 12),
                  SegmentedButton<RequesterType>(
                    segments: RequesterType.values
                        .map(
                          (t) => ButtonSegment(
                            value: t,
                            label: Text(t.label, overflow: TextOverflow.ellipsis),
                          ),
                        )
                        .toList(),
                    selected: {_type},
                    onSelectionChanged: (s) => setState(() => _type = s.first),
                  ),
                  if (_type == RequesterType.hospital) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Have hospital registration ready if staff call you.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.onSurface.withValues(alpha: 0.6),
                          ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Organization / name *',
                      prefixIcon: Icon(Icons.business_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  PhoneNumberFieldList(
                    phones: _phones,
                    onChanged: (p) => setState(() => _phones = p),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _streetController,
                    decoration: const InputDecoration(labelText: 'Street'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _areaController,
                    decoration: const InputDecoration(labelText: 'Area'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _cityController,
                    decoration: const InputDecoration(labelText: 'City'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _postalController,
                    decoration: const InputDecoration(labelText: 'Postal code'),
                  ),
                ] else ...[
                  Text('What blood is needed?',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<BloodGroup>(
                    initialValue: _bloodGroup,
                    decoration: const InputDecoration(labelText: 'Blood group *'),
                    items: [
                      for (final g in BloodGroup.values)
                        DropdownMenuItem(value: g, child: Text(g.label)),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _bloodGroup = v);
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Units needed *'),
                      const Spacer(),
                      IconButton(
                        onPressed:
                            _quantity > 1 ? () => setState(() => _quantity--) : null,
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text('$_quantity'),
                      IconButton(
                        onPressed: _quantity < 20
                            ? () => setState(() => _quantity++)
                            : null,
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Urgency *',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  RadioGroup<Urgency>(
                    groupValue: _urgency,
                    onChanged: (v) {
                      if (v != null) setState(() => _urgency = v);
                    },
                    child: Column(
                      children: [
                        for (final u in Urgency.values)
                          RadioListTile<Urgency>(
                            title: Text(u.label),
                            subtitle: u == Urgency.critical
                                ? const Text('Life-threatening emergency')
                                : null,
                            value: u,
                          ),
                      ],
                    ),
                  ),
                  if (isCritical)
                    Card(
                      color: scheme.errorContainer,
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          'Critical requests are prioritized. Staff may call to verify.',
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Need help? Call ${AppRoutes.staffBranchHotline}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  TextButton(onPressed: _callBranch, child: const Text('Call blood bank')),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: _submitting
                        ? null
                        : () {
                            if (_step == 0) {
                              if (_validateStep1()) setState(() => _step = 1);
                            } else {
                              _submit();
                            }
                          },
                    child: _submitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(_step == 0 ? 'Next' : 'Submit request'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
