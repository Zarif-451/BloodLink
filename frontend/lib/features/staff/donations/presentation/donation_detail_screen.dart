import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/widgets/widgets.dart';
import 'package:frontend/data/models/donation.dart';
import 'package:frontend/data/models/donor.dart';
import 'package:frontend/data/models/inventory_unit.dart';
import 'package:frontend/data/models/screening.dart';
import 'package:frontend/data/repositories/donation_repository.dart';
import 'package:frontend/data/repositories/donor_repository.dart';
import 'package:frontend/data/repositories/inventory_repository.dart';
import 'package:frontend/data/repositories/screening_repository.dart';
import 'package:frontend/features/staff/donors/presentation/donor_utils.dart';

class DonationDetailScreen extends StatefulWidget {
  const DonationDetailScreen({super.key, required this.donationId});

  final int donationId;

  @override
  State<DonationDetailScreen> createState() => _DonationDetailScreenState();
}

class _DonationDetailScreenState extends State<DonationDetailScreen> {
  Donation? _donation;
  Donor? _donor;
  Screening? _screening;
  InventoryUnit? _inventory;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final donationRepo = context.read<DonationRepository>();
    final donorRepo = context.read<DonorRepository>();
    final screeningRepo = context.read<ScreeningRepository>();
    final inventoryRepo = context.read<InventoryRepository>();

    final donation = await donationRepo.getDonation(widget.donationId);
    if (donation == null) {
      if (mounted) context.pop();
      return;
    }
    final donor = await donorRepo.getDonor(donation.nationalId);
    final screening =
        await screeningRepo.getScreeningForDonation(widget.donationId);
    final inventory =
        await inventoryRepo.getUnitByDonation(widget.donationId);

    if (!mounted) return;
    setState(() {
      _donation = donation;
      _donor = donor;
      _screening = screening;
      _inventory = inventory;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _donation == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Donation')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final donation = _donation!;
    final screening = _screening;

    return Scaffold(
      appBar: AppBar(title: Text('Donation #${donation.id}')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (_donor != null)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.person_outline),
              title: Text(_donor!.fullName),
              subtitle: Text('NID ${maskNationalId(_donor!.nationalId)}'),
              trailing: BloodGroupChip(group: _donor!.bloodGroup.label),
              onTap: () =>
                  context.push(AppRoutes.staffDonorDetail(_donor!.nationalId)),
            ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Donation date'),
            subtitle: Text(DateFormat.yMMMd().format(donation.donationDate)),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Units donated'),
            subtitle: Text('${donation.unitsDonated}'),
          ),
          if (donation.eligibleNextDate != null)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Next eligible'),
              subtitle:
                  Text(DateFormat.yMMMd().format(donation.eligibleNextDate!)),
            ),
          const SizedBox(height: 16),
          Text('Screening results',
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          if (screening == null)
            const Text('Pending screening')
          else ...[
            StatusPill(
              label: screening.result.label,
              tone: screening.result == ScreeningResult.pass
                  ? StatusTone.success
                  : StatusTone.critical,
            ),
            const SizedBox(height: 12),
            Text('Hb: ${screening.hbLevel ?? '—'} g/dL'),
            Text('BP: ${screening.bp ?? '—'}'),
            const SizedBox(height: 8),
            _DiseaseRow(label: 'Hepatitis B', pass: screening.hepatitisB),
            _DiseaseRow(label: 'Hepatitis C', pass: screening.hepatitisC),
            _DiseaseRow(label: 'HIV', pass: screening.hiv),
            _DiseaseRow(label: 'Malaria', pass: screening.malaria),
            const SizedBox(height: 8),
            Text('Tested ${DateFormat.yMMMd().add_jm().format(screening.testedOn)}'),
          ],
          const SizedBox(height: 16),
          if (_inventory != null)
            OutlinedButton(
              onPressed: () => context.push(
                AppRoutes.staffInventoryDetail(_inventory!.id),
              ),
              child: Text('View inventory unit ${_inventory!.unitNumber}'),
            )
          else if (screening?.result == ScreeningResult.pass)
            FilledButton(
              onPressed: () => context.push(
                '${AppRoutes.staffInventoryAdd}?donationId=${donation.id}',
              ),
              child: const Text('Add to inventory'),
            ),
        ],
      ),
    );
  }
}

class _DiseaseRow extends StatelessWidget {
  const _DiseaseRow({required this.label, required this.pass});

  final String label;
  final bool pass;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          pass ? Icons.check : Icons.close,
          size: 16,
          color: pass ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 8),
        Text('$label: ${pass ? 'Pass' : 'Fail'}'),
      ],
    );
  }
}
