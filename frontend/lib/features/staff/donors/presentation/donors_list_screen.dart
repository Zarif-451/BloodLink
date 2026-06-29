import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/widgets/widgets.dart';
import 'package:frontend/data/models/donor.dart';
import 'package:frontend/data/repositories/donor_repository.dart';
import 'package:frontend/features/staff/donors/presentation/donor_utils.dart';

class DonorsListScreen extends StatefulWidget {
  const DonorsListScreen({super.key});

  @override
  State<DonorsListScreen> createState() => _DonorsListScreenState();
}

class _DonorsListScreenState extends State<DonorsListScreen> {
  List<Donor> _donors = [];
  bool _loading = true;
  String _query = '';
  BloodGroup? _bloodGroupFilter;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final repo = context.read<DonorRepository>();
    final list = await repo.getDonors(query: _query);
    if (!mounted) return;
    setState(() {
      _donors = _bloodGroupFilter == null
          ? list
          : list.where((d) => d.bloodGroup == _bloodGroupFilter).toList();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: SearchDonorBar(
            onChanged: (value) {
              _query = value;
              _load();
            },
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              for (final group in BloodGroup.values)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(group.label),
                    selected: _bloodGroupFilter == group,
                    onSelected: (_) {
                      setState(() => _bloodGroupFilter = group);
                      _load();
                    },
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _donors.isEmpty
                  ? EmptyState(
                      message: _query.isEmpty
                          ? 'No donors yet'
                          : 'No donors match your search',
                      icon: Icons.people_outline,
                      actionLabel: _query.isEmpty ? 'Register donor' : null,
                      onAction: _query.isEmpty
                          ? () => context.push(AppRoutes.staffDonorRegister)
                          : null,
                    )
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: _donors.length,
                        itemBuilder: (context, index) {
                          final donor = _donors[index];
                          return _DonorListTile(donor: donor);
                        },
                      ),
                    ),
        ),
      ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.staffDonorRegister),
        icon: const Icon(Icons.person_add_outlined),
        label: const Text('Register'),
      ),
    );
  }
}

class _DonorListTile extends StatelessWidget {
  const _DonorListTile({required this.donor});

  final Donor donor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final lastDonated = donor.lastDonationDate != null
        ? DateFormat.yMMMd().format(donor.lastDonationDate!)
        : 'Never';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: () => context.push(AppRoutes.staffDonorDetail(donor.nationalId)),
        title: Row(
          children: [
            Expanded(
              child: Text(
                donor.fullName,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            BloodGroupChip(group: donor.bloodGroup.label),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('NID: ${maskNationalId(donor.nationalId)}'),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  donor.isEligible ? Icons.check_circle : Icons.schedule,
                  size: 14,
                  color: donor.isEligible ? scheme.primary : scheme.outline,
                ),
                const SizedBox(width: 4),
                Text(eligibilityLabel(donor)),
              ],
            ),
            Text('Last donated: $lastDonated'),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
