import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/widgets/empty_state.dart';
import 'package:frontend/core/widgets/status_pill.dart';
import 'package:frontend/data/models/donation.dart';
import 'package:frontend/data/models/donor.dart';
import 'package:frontend/data/repositories/donation_repository.dart';
import 'package:frontend/data/repositories/donor_repository.dart';
import 'package:frontend/data/repositories/screening_repository.dart';

class DonorDonationHistoryScreen extends StatefulWidget {
  const DonorDonationHistoryScreen({super.key, required this.nationalId});

  final String nationalId;

  @override
  State<DonorDonationHistoryScreen> createState() =>
      _DonorDonationHistoryScreenState();
}

class _DonorDonationHistoryScreenState
    extends State<DonorDonationHistoryScreen> {
  Donor? _donor;
  List<Donation> _donations = [];
  bool _loading = true;
  ScreeningResult? _filter;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final donorRepo = context.read<DonorRepository>();
    final donationRepo = context.read<DonationRepository>();
    final donor = await donorRepo.getDonor(widget.nationalId);
    final donations =
        await donationRepo.getDonationsForDonor(widget.nationalId);
    if (!mounted) return;
    setState(() {
      _donor = donor;
      _donations = donations;
      _loading = false;
    });
  }

  Future<ScreeningResult?> _screeningResult(int donationId) async {
    final screening = await context
        .read<ScreeningRepository>()
        .getScreeningForDonation(donationId);
    return screening?.result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Donation history'),
            if (_donor != null)
              Text(
                _donor!.fullName,
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _donations.isEmpty
              ? const EmptyState(
                  message: 'No donations recorded yet',
                  icon: Icons.history,
                )
              : Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          FilterChip(
                            label: const Text('All'),
                            selected: _filter == null,
                            onSelected: (_) => setState(() => _filter = null),
                          ),
                          const SizedBox(width: 8),
                          FilterChip(
                            label: const Text('Pass'),
                            selected: _filter == ScreeningResult.pass,
                            onSelected: (_) =>
                                setState(() => _filter = ScreeningResult.pass),
                          ),
                          const SizedBox(width: 8),
                          FilterChip(
                            label: const Text('Fail'),
                            selected: _filter == ScreeningResult.fail,
                            onSelected: (_) =>
                                setState(() => _filter = ScreeningResult.fail),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _load,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _donations.length,
                          itemBuilder: (context, index) {
                            final donation = _donations[index];
                            return _HistoryTile(
                              donation: donation,
                              filter: _filter,
                              screeningResult: _screeningResult,
                              onTap: () => context.push(
                                AppRoutes.staffDonationDetail(donation.id),
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

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({
    required this.donation,
    required this.filter,
    required this.screeningResult,
    required this.onTap,
  });

  final Donation donation;
  final ScreeningResult? filter;
  final Future<ScreeningResult?> Function(int) screeningResult;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ScreeningResult?>(
      future: screeningResult(donation.id),
      builder: (context, snapshot) {
        final result = snapshot.data;
        if (filter != null && result != filter) {
          return const SizedBox.shrink();
        }

        final resultLabel = result == null
            ? 'Pending screening'
            : result == ScreeningResult.pass
                ? 'Pass'
                : 'Fail';
        final tone = result == ScreeningResult.fail
            ? StatusTone.critical
            : result == ScreeningResult.pass
                ? StatusTone.success
                : StatusTone.warning;

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            onTap: onTap,
            title: Text(DateFormat.yMMMd().format(donation.donationDate)),
            subtitle: Text('${donation.unitsDonated} unit(s)'),
            trailing: StatusPill(label: resultLabel, tone: tone),
          ),
        );
      },
    );
  }
}
