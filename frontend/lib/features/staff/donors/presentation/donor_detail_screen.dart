import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/widgets/widgets.dart';
import 'package:frontend/data/models/donor.dart';
import 'package:frontend/data/repositories/donation_repository.dart';
import 'package:frontend/data/repositories/donor_repository.dart';
import 'package:frontend/features/staff/donors/presentation/donor_utils.dart';

class DonorDetailScreen extends StatefulWidget {
  const DonorDetailScreen({super.key, required this.nationalId});

  final String nationalId;

  @override
  State<DonorDetailScreen> createState() => _DonorDetailScreenState();
}

class _DonorDetailScreenState extends State<DonorDetailScreen> {
  Donor? _donor;
  int _totalDonations = 0;
  int _totalUnits = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final donorRepo = context.read<DonorRepository>();
    final donationRepo = context.read<DonationRepository>();
    final donor = await donorRepo.getDonor(widget.nationalId);
    final donations = await donationRepo.getDonationsForDonor(widget.nationalId);
    if (!mounted) return;
    if (donor == null) {
      context.pop();
      return;
    }
    setState(() {
      _donor = donor;
      _totalDonations = donations.length;
      _totalUnits = donations.fold(0, (sum, d) => sum + d.unitsDonated);
      _loading = false;
    });
  }

  void _recordDonation() {
    if (_donor == null || !_donor!.isEligible) return;
    context.push(
      '${AppRoutes.staffRecordDonation}?nationalId=${Uri.encodeComponent(_donor!.nationalId)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _donor == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Donor profile')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final donor = _donor!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Donor profile'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  context.push(AppRoutes.staffDonorEdit(donor.nationalId));
                case 'history':
                  context.push(AppRoutes.staffDonorHistory(donor.nationalId));
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit')),
              PopupMenuItem(value: 'history', child: Text('View history')),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                child: Text(
                  donor.fullName.isNotEmpty
                      ? donor.fullName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      donor.fullName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        BloodGroupChip(group: donor.bloodGroup.label),
                        const SizedBox(width: 8),
                        Text('NID ${maskNationalId(donor.nationalId)}'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          EligibilityCard(
            isEligible: donor.isEligible,
            eligibleNextDate: donor.eligibleNextDate,
          ),
          const SizedBox(height: 16),
          Text('Contact & address',
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          if (donor.phones.isNotEmpty)
            ...donor.phones.map((p) => ListTile(
                  leading: const Icon(Icons.phone_outlined),
                  title: Text(p),
                  contentPadding: EdgeInsets.zero,
                )),
          if (donor.city.isNotEmpty)
            ListTile(
              leading: const Icon(Icons.location_on_outlined),
              title: Text(
                [donor.street, donor.area, donor.city, donor.postalCode]
                    .where((s) => s.isNotEmpty)
                    .join(', '),
              ),
              contentPadding: EdgeInsets.zero,
            ),
          ListTile(
            leading: const Icon(Icons.cake_outlined),
            title: Text(DateFormat.yMMMd().format(donor.dateOfBirth)),
            subtitle: Text(donor.gender == Gender.male ? 'Male' : 'Female'),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SummaryStatCard(
                  label: 'Donations',
                  value: '$_totalDonations',
                  icon: Icons.bloodtype_outlined,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SummaryStatCard(
                  label: 'Units',
                  value: '$_totalUnits',
                  icon: Icons.water_drop_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Tooltip(
            message: donor.isEligible
                ? ''
                : 'Donor is not eligible until ${donor.eligibleNextDate != null ? DateFormat.yMMMd().format(donor.eligibleNextDate!) : 'later'}',
            child: FilledButton.icon(
              onPressed: donor.isEligible ? _recordDonation : null,
              icon: const Icon(Icons.bloodtype_outlined),
              label: const Text('Record donation'),
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () =>
                context.push(AppRoutes.staffDonorHistory(donor.nationalId)),
            child: const Text('View donation history'),
          ),
        ],
      ),
    );
  }
}
