import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/core/providers/auth_controller.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/widgets/blood_group_chip.dart';
import 'package:frontend/data/mock/mock_data.dart';
import 'package:frontend/data/models/donation.dart';
import 'package:frontend/data/models/donor.dart';
import 'package:frontend/data/repositories/donation_repository.dart';
import 'package:frontend/data/repositories/donor_repository.dart';
import 'package:frontend/features/staff/donors/presentation/donor_utils.dart';

class RecordDonationScreen extends StatefulWidget {
  const RecordDonationScreen({super.key, required this.nationalId});

  final String nationalId;

  @override
  State<RecordDonationScreen> createState() => _RecordDonationScreenState();
}

class _RecordDonationScreenState extends State<RecordDonationScreen> {
  Donor? _donor;
  bool _loading = true;
  bool _saving = false;
  int _units = 1;
  DateTime _donationDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final donor =
        await context.read<DonorRepository>().getDonor(widget.nationalId);
    if (!mounted) return;
    if (donor == null || !donor.isEligible) {
      context.pop();
      return;
    }
    setState(() {
      _donor = donor;
      _loading = false;
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _donationDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _donationDate = picked);
  }

  Future<void> _save() async {
    if (_donor == null) return;
    if (_donationDate.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Donation date cannot be in the future')),
      );
      return;
    }

    setState(() => _saving = true);
    final eligibleNext = _donationDate.add(const Duration(days: 56));
    final donation = Donation(
      id: 0,
      nationalId: _donor!.nationalId,
      unitsDonated: _units,
      donationDate: _donationDate,
      eligibleNextDate: eligibleNext,
    );

    final created =
        await context.read<DonationRepository>().createDonation(donation);
    if (!mounted) return;
    setState(() => _saving = false);
    context.go(AppRoutes.staffScreening(created.id));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _donor == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Record donation')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final user = context.watch<AuthController>().user;
    final branch = MockData.branches.firstWhere((b) => b.id == user?.branchId);
    final donor = _donor!;
    final eligiblePreview = _donationDate.add(const Duration(days: 56));

    return Scaffold(
      appBar: AppBar(title: const Text('Record donation')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: ListTile(
              leading: CircleAvatar(child: Text(donor.fullName[0])),
              title: Text(donor.fullName),
              subtitle: Text('NID ${maskNationalId(donor.nationalId)}'),
              trailing: BloodGroupChip(group: donor.bloodGroup.label),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Units donated'),
              const Spacer(),
              IconButton(
                onPressed: _units > 1 ? () => setState(() => _units--) : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text('$_units', style: Theme.of(context).textTheme.titleMedium),
              IconButton(
                onPressed: _units < 2 ? () => setState(() => _units++) : null,
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Donation date'),
            subtitle: Text(
              '${_donationDate.day}/${_donationDate.month}/${_donationDate.year}',
            ),
            trailing: const Icon(Icons.calendar_today_outlined),
            onTap: _pickDate,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Branch'),
            subtitle: Text(branch.name),
          ),
          const SizedBox(height: 8),
          Text(
            'Eligible next date will be set to '
            '${eligiblePreview.day}/${eligiblePreview.month}/${eligiblePreview.year} (+56 days)',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save & screen'),
          ),
        ],
      ),
    );
  }
}
