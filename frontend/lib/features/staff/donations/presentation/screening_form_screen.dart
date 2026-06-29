import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/core/providers/auth_controller.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/data/models/donation.dart';
import 'package:frontend/data/models/donor.dart';
import 'package:frontend/data/models/screening.dart';
import 'package:frontend/data/repositories/donation_repository.dart';
import 'package:frontend/data/repositories/donor_repository.dart';
import 'package:frontend/data/repositories/screening_repository.dart';

class ScreeningFormScreen extends StatefulWidget {
  const ScreeningFormScreen({super.key, required this.donationId});

  final int donationId;

  @override
  State<ScreeningFormScreen> createState() => _ScreeningFormScreenState();
}

class _ScreeningFormScreenState extends State<ScreeningFormScreen> {
  Donation? _donation;
  Donor? _donor;
  bool _loading = true;
  bool _submitting = false;

  final _hbController = TextEditingController(text: '14.0');
  final _bpController = TextEditingController(text: '120/80');
  DateTime _testedOn = DateTime.now();

  bool _hepatitisB = true;
  bool _hepatitisC = true;
  bool _hiv = true;
  bool _malaria = true;
  ScreeningResult _result = ScreeningResult.pass;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final donationRepo = context.read<DonationRepository>();
    final donorRepo = context.read<DonorRepository>();
    final donation =
        await donationRepo.getDonation(widget.donationId);
    if (donation == null) {
      if (mounted) context.pop();
      return;
    }
    final donor = await donorRepo.getDonor(donation.nationalId);
    if (!mounted) return;
    setState(() {
      _donation = donation;
      _donor = donor;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _hbController.dispose();
    _bpController.dispose();
    super.dispose();
  }

  void _updateOverallResult() {
    final autoFail = !_hepatitisB || !_hepatitisC || !_hiv || !_malaria;
    setState(() {
      _result = autoFail ? ScreeningResult.fail : ScreeningResult.pass;
    });
  }

  Future<void> _submit() async {
    if (_donation == null) return;

    final screeningRepo = context.read<ScreeningRepository>();
    final userId = context.read<AuthController>().user?.id ?? 1;

    final hb = double.tryParse(_hbController.text.trim());
    if (hb == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid Hb level')),
      );
      return;
    }
    if (_bpController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Blood pressure is required')),
      );
      return;
    }

    if (_result == ScreeningResult.pass &&
        (!_hepatitisB || !_hepatitisC || !_hiv || !_malaria)) {
      final override = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Override result?'),
          content: const Text(
            'One or more disease tests failed. Override to Pass anyway?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Override'),
            ),
          ],
        ),
      );
      if (override != true) return;
    }

    setState(() => _submitting = true);
    final screening = Screening(
      id: 0,
      donationId: widget.donationId,
      testedOn: _testedOn,
      testedByUserId: userId,
      result: _result,
      hbLevel: hb,
      bp: _bpController.text.trim(),
      hepatitisB: _hepatitisB,
      hepatitisC: _hepatitisC,
      hiv: _hiv,
      malaria: _malaria,
    );

    await screeningRepo.createScreening(screening);
    if (!mounted) return;
    setState(() => _submitting = false);

    if (_result == ScreeningResult.pass) {
      context.go(
        '${AppRoutes.staffInventoryAdd}?donationId=${widget.donationId}',
      );
    } else {
      context.go(AppRoutes.staffDonationDetail(widget.donationId));
    }
  }

  Widget _diseaseToggle(String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: true, label: Text('Pass')),
              ButtonSegment(value: false, label: Text('Fail')),
            ],
            selected: {value},
            onSelectionChanged: (s) {
              onChanged(s.first);
              _updateOverallResult();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Screening')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Screening'),
            Text(
              'Donor: ${_donor?.fullName ?? '—'} · Donation #${widget.donationId}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Vitals', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 12),
          TextField(
            controller: _hbController,
            decoration: const InputDecoration(
              labelText: 'Hb level (g/dL) *',
              hintText: '12.5–17.5',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _bpController,
            decoration: const InputDecoration(
              labelText: 'Blood pressure *',
              hintText: '120/80',
            ),
          ),
          const SizedBox(height: 24),
          Text('Infectious disease screening',
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 12),
          _diseaseToggle('Hepatitis B', _hepatitisB, (v) => setState(() => _hepatitisB = v)),
          _diseaseToggle('Hepatitis C', _hepatitisC, (v) => setState(() => _hepatitisC = v)),
          _diseaseToggle('HIV', _hiv, (v) => setState(() => _hiv = v)),
          _diseaseToggle('Malaria', _malaria, (v) => setState(() => _malaria = v)),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Tested on'),
            subtitle: Text(DateFormat.yMMMd().add_jm().format(_testedOn)),
            trailing: const Icon(Icons.schedule),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _testedOn,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (date == null || !context.mounted) return;
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(_testedOn),
              );
              if (time == null || !mounted) return;
              setState(() {
                _testedOn = DateTime(
                  date.year,
                  date.month,
                  date.day,
                  time.hour,
                  time.minute,
                );
              });
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Tested by'),
            subtitle: Text(context.watch<AuthController>().user?.fullName ?? 'Staff'),
          ),
          const SizedBox(height: 16),
          SegmentedButton<ScreeningResult>(
            segments: const [
              ButtonSegment(value: ScreeningResult.pass, label: Text('Pass')),
              ButtonSegment(value: ScreeningResult.fail, label: Text('Fail')),
            ],
            selected: {_result},
            onSelectionChanged: (s) => setState(() => _result = s.first),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Submit screening'),
          ),
        ],
      ),
    );
  }
}
