import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/core/providers/auth_controller.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/theme/bloodlink_colors.dart';
import 'package:frontend/core/widgets/widgets.dart';
import 'package:frontend/data/mock/mock_data.dart';
import 'package:frontend/data/models/donation.dart';
import 'package:frontend/data/repositories/donation_repository.dart';
import 'package:frontend/data/repositories/donor_repository.dart';
import 'package:frontend/data/repositories/inventory_repository.dart';
import 'package:frontend/data/repositories/request_repository.dart';
import 'package:frontend/data/repositories/screening_repository.dart';

class StaffDashboardScreen extends StatefulWidget {
  const StaffDashboardScreen({super.key});

  @override
  State<StaffDashboardScreen> createState() => _StaffDashboardScreenState();
}

class _StaffDashboardScreenState extends State<StaffDashboardScreen> {
  int _pending = 0;
  int _stock = 0;
  int _donors = 0;
  int _expiring = 0;
  int _donationsToday = 0;
  int _pendingScreenings = 0;
  List<Donation> _screeningQueue = [];
  Map<int, String> _donorNamesByDonation = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final branchId = context.read<AuthController>().user?.branchId;
    final requestRepo = context.read<RequestRepository>();
    final inventoryRepo = context.read<InventoryRepository>();
    final donorRepo = context.read<DonorRepository>();
    final donationRepo = context.read<DonationRepository>();
    final screeningRepo = context.read<ScreeningRepository>();

    final pendingList =
        await requestRepo.getRequests(status: RequestStatus.pending);
    final stockCount = await inventoryRepo.countAvailable(branchId: branchId);
    final expiring =
        await inventoryRepo.countExpiringSoon(branchId: branchId);
    final donorList = await donorRepo.getDonors();
    final donationsToday = await donationRepo.countDonationsToday();
    final screeningQueue =
        await screeningRepo.getDonationsPendingScreening();
    final donorNames = <int, String>{};
    for (final donation in screeningQueue.take(3)) {
      final donor = await donorRepo.getDonor(donation.nationalId);
      donorNames[donation.id] = donor?.fullName ?? donation.nationalId;
    }

    if (!mounted) return;
    setState(() {
      _pending = pendingList.length;
      _stock = stockCount;
      _donors = donorList.length;
      _expiring = expiring;
      _donationsToday = donationsToday;
      _pendingScreenings = screeningQueue.length;
      _screeningQueue = screeningQueue.take(3).toList();
      _donorNamesByDonation = donorNames;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthController>().user;
    final branch = MockData.branches.firstWhere((b) => b.id == user?.branchId);
    final ext = BloodlinkColors.of(context);

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadStats,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Good morning, ${user?.fullName ?? 'Staff'}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          Text(
            branch.name,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.55),
                ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.35,
            children: [
              SummaryStatCard(
                label: 'Pending requests',
                value: '$_pending',
                icon: Icons.pending_actions_outlined,
                onTap: () => context.go(AppRoutes.staffRequests),
              ),
              SummaryStatCard(
                label: 'Units in stock',
                value: '$_stock',
                icon: Icons.inventory_2_outlined,
                onTap: () => context.go(AppRoutes.staffInventory),
              ),
              SummaryStatCard(
                label: 'Donors',
                value: '$_donors',
                icon: Icons.volunteer_activism_outlined,
                onTap: () => context.go(AppRoutes.staffDonors),
              ),
              SummaryStatCard(
                label: 'Expiring ≤7 days',
                value: '$_expiring',
                icon: Icons.schedule_outlined,
                onTap: () => context.go(AppRoutes.staffInventory),
              ),
              SummaryStatCard(
                label: 'Donations today',
                value: '$_donationsToday',
                icon: Icons.bloodtype_outlined,
              ),
              SummaryStatCard(
                label: 'Pending screenings',
                value: '$_pendingScreenings',
                icon: Icons.biotech_outlined,
              ),
            ],
          ),
          if (_expiring > 0) ...[
            const SizedBox(height: 16),
            Card(
              color: ext.warning.withValues(alpha: 0.1),
              child: ListTile(
                leading: Icon(Icons.warning_amber_outlined, color: ext.warning),
                title: const Text('Low stock / near expiry'),
                subtitle: Text(
                  '$_expiring unit(s) expiring within 7 days. Review inventory.',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.go(AppRoutes.staffInventory),
              ),
            ),
          ],
          const SizedBox(height: 24),
          Text(
            'Quick actions',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: () => context.push(AppRoutes.staffSelectDonor),
                icon: const Icon(Icons.bloodtype_outlined),
                label: const Text('Record donation'),
              ),
              OutlinedButton.icon(
                onPressed: () => context.push(AppRoutes.staffDonorRegister),
                icon: const Icon(Icons.person_add_outlined),
                label: const Text('Register donor'),
              ),
              OutlinedButton.icon(
                onPressed: () => context.go(AppRoutes.staffRequests),
                icon: const Icon(Icons.pending_actions_outlined),
                label: const Text('Requests'),
              ),
            ],
          ),
          if (_screeningQueue.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              'Pending screenings',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            for (final donation in _screeningQueue)
              Card(
                child: ListTile(
                  title: Text(
                    _donorNamesByDonation[donation.id] ?? donation.nationalId,
                  ),
                  subtitle: Text(
                    'Donation #${donation.id} · '
                    '${DateFormat.yMMMd().format(donation.donationDate)}',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(
                    AppRoutes.staffScreening(donation.id),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
