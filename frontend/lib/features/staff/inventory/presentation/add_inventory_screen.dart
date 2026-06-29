import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/core/providers/auth_controller.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/widgets/blood_group_chip.dart';
import 'package:frontend/data/models/donation.dart';
import 'package:frontend/data/models/donor.dart';
import 'package:frontend/data/models/inventory_unit.dart';
import 'package:frontend/data/models/screening.dart';
import 'package:frontend/data/repositories/donation_repository.dart';
import 'package:frontend/data/repositories/donor_repository.dart';
import 'package:frontend/data/repositories/inventory_repository.dart';
import 'package:frontend/data/repositories/screening_repository.dart';

class AddInventoryScreen extends StatefulWidget {
  const AddInventoryScreen({super.key, required this.donationId});

  final int donationId;

  @override
  State<AddInventoryScreen> createState() => _AddInventoryScreenState();
}

class _AddInventoryScreenState extends State<AddInventoryScreen> {
  Donation? _donation;
  Donor? _donor;
  Screening? _screening;
  bool _loading = true;
  bool _saving = false;

  final _unitNumberController = TextEditingController();
  int _quantity = 1;
  late DateTime _collectionDate;
  late DateTime _expiryDate;

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
    final auth = context.read<AuthController>();

    final donation = await donationRepo.getDonation(widget.donationId);
    if (donation == null) {
      if (mounted) context.pop();
      return;
    }

    final screening =
        await screeningRepo.getScreeningForDonation(widget.donationId);
    if (screening == null || screening.result != ScreeningResult.pass) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Screening must pass before inventory')),
        );
        context.pop();
      }
      return;
    }

    final existing = await inventoryRepo.getUnitByDonation(widget.donationId);
    if (existing != null && mounted) {
      context.go(AppRoutes.staffInventoryDetail(existing.id));
      return;
    }

    final donor = await donorRepo.getDonor(donation.nationalId);
    if (!mounted) return;
    final branchId = auth.user?.branchId ?? 1;
    final unitNumber = inventoryRepo.suggestUnitNumber(
      branchId: branchId,
      bloodGroup: donor!.bloodGroup,
    );

    if (!mounted) return;
    setState(() {
      _donation = donation;
      _donor = donor;
      _screening = screening;
      _collectionDate = donation.donationDate;
      _expiryDate = donation.donationDate.add(const Duration(days: 35));
      _unitNumberController.text = unitNumber;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _unitNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickExpiry() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate,
      firstDate: _collectionDate,
      lastDate: _collectionDate.add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _expiryDate = picked);
  }

  Future<void> _submit() async {
    if (_donor == null || _donation == null) return;
    if (_unitNumberController.text.trim().isEmpty) return;
    if (!_expiryDate.isAfter(_collectionDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expiry must be after collection date')),
      );
      return;
    }

    setState(() => _saving = true);
    final branchId = context.read<AuthController>().user?.branchId ?? 1;
    final unit = InventoryUnit(
      id: 0,
      branchId: branchId,
      bloodGroup: _donor!.bloodGroup,
      unitNumber: _unitNumberController.text.trim(),
      collectionDate: _collectionDate,
      expiryDate: _expiryDate,
      quantity: _quantity,
      status: InventoryStatus.available,
      sourceDonationId: widget.donationId,
    );

    final created = await context.read<InventoryRepository>().addUnit(unit);
    if (!mounted) return;
    setState(() => _saving = false);
    context.go(AppRoutes.staffInventoryDetail(created.id));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Add to inventory')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Add to inventory')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('From screening #${_screening?.id ?? '—'}'),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Donor blood group: '),
              BloodGroupChip(group: _donor!.bloodGroup.label),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _unitNumberController,
            decoration: const InputDecoration(labelText: 'Unit number *'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Quantity'),
              const Spacer(),
              IconButton(
                onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text('$_quantity'),
              IconButton(
                onPressed: () => setState(() => _quantity++),
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Collection date'),
            subtitle: Text(
              '${_collectionDate.day}/${_collectionDate.month}/${_collectionDate.year}',
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Expiry date *'),
            subtitle: Text(
              '${_expiryDate.day}/${_expiryDate.month}/${_expiryDate.year}',
            ),
            trailing: const Icon(Icons.calendar_today_outlined),
            onTap: _pickExpiry,
          ),
          const SizedBox(height: 8),
          const Text('Status: Available (on create)'),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _saving ? null : _submit,
            child: _saving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Add to stock'),
          ),
        ],
      ),
    );
  }
}
