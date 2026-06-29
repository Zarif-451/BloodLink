import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/widgets/widgets.dart';
import 'package:frontend/data/models/donor.dart';
import 'package:frontend/data/repositories/donor_repository.dart';
import 'package:frontend/features/staff/donors/presentation/donor_utils.dart';

class SelectDonorScreen extends StatefulWidget {
  const SelectDonorScreen({super.key});

  @override
  State<SelectDonorScreen> createState() => _SelectDonorScreenState();
}

class _SelectDonorScreenState extends State<SelectDonorScreen> {
  List<Donor> _donors = [];
  bool _loading = true;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final list = await context.read<DonorRepository>().getDonors(query: _query);
    if (!mounted) return;
    setState(() {
      _donors = list;
      _loading = false;
    });
  }

  void _selectDonor(Donor donor) {
    if (!donor.isEligible) {
      showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (context) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Not eligible',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                donor.eligibleNextDate != null
                    ? 'This donor cannot donate until ${donor.eligibleNextDate!.toLocal().toString().split(' ').first}.'
                    : 'This donor is not eligible to donate yet.',
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        ),
      );
      return;
    }

    context.push(
      '${AppRoutes.staffRecordDonation}?nationalId=${Uri.encodeComponent(donor.nationalId)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select donor')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchDonorBar(onChanged: (v) {
              _query = v;
              _load();
            }),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _donors.length,
                    itemBuilder: (context, index) {
                      final donor = _donors[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          onTap: () => _selectDonor(donor),
                          title: Row(
                            children: [
                              Expanded(child: Text(donor.fullName)),
                              BloodGroupChip(group: donor.bloodGroup.label),
                            ],
                          ),
                          subtitle: Text(
                            'NID ${maskNationalId(donor.nationalId)} · ${eligibilityLabel(donor)}',
                          ),
                        ),
                      );
                    },
                  ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: OutlinedButton(
                onPressed: () => context.push(
                  '${AppRoutes.staffDonorRegister}?return=donation',
                ),
                child: const Text('Register walk-in donor'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
