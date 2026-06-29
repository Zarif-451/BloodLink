import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/widgets/blood_group_chip.dart';
import 'package:frontend/core/widgets/phone_number_field_list.dart';
import 'package:frontend/data/models/donor.dart';
import 'package:frontend/data/repositories/donor_repository.dart';
import 'package:frontend/features/staff/donors/presentation/donor_utils.dart';

class EditDonorScreen extends StatefulWidget {
  const EditDonorScreen({super.key, required this.nationalId});

  final String nationalId;

  @override
  State<EditDonorScreen> createState() => _EditDonorScreenState();
}

class _EditDonorScreenState extends State<EditDonorScreen> {
  final _formKey = GlobalKey<FormState>();
  Donor? _donor;
  bool _loading = true;
  bool _saving = false;

  final _fullNameController = TextEditingController();
  final _streetController = TextEditingController();
  final _areaController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalController = TextEditingController();
  DateTime? _dateOfBirth;
  Gender _gender = Gender.male;
  List<String> _phones = [''];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final donor =
        await context.read<DonorRepository>().getDonor(widget.nationalId);
    if (!mounted) return;
    if (donor == null) {
      context.pop();
      return;
    }
    _fullNameController.text = donor.fullName;
    _streetController.text = donor.street;
    _areaController.text = donor.area;
    _cityController.text = donor.city;
    _postalController.text = donor.postalCode;
    setState(() {
      _donor = donor;
      _dateOfBirth = donor.dateOfBirth;
      _gender = donor.gender;
      _phones = donor.phones.isEmpty ? [''] : List.of(donor.phones);
      _loading = false;
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _streetController.dispose();
    _areaController.dispose();
    _cityController.dispose();
    _postalController.dispose();
    super.dispose();
  }

  Future<void> _pickDateOfBirth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime(2000),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _dateOfBirth = picked);
  }

  Future<void> _save() async {
    if (_donor == null || !_formKey.currentState!.validate()) return;
    if (_dateOfBirth == null || !isDonorAdult(_dateOfBirth!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Donor must be 18 or older')),
      );
      return;
    }

    setState(() => _saving = true);
    final phones = _phones.where((p) => p.trim().isNotEmpty).toList();
    if (phones.isEmpty) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('At least one phone is required')),
      );
      return;
    }

    final updated = _donor!.copyWith(
      fullName: _fullNameController.text.trim(),
      dateOfBirth: _dateOfBirth,
      gender: _gender,
      street: _streetController.text.trim(),
      area: _areaController.text.trim(),
      city: _cityController.text.trim(),
      postalCode: _postalController.text.trim(),
      phones: phones,
    );

    await context.read<DonorRepository>().updateDonor(updated);
    if (!mounted) return;
    context.go(AppRoutes.staffDonorDetail(widget.nationalId));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _donor == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit donor')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Edit donor')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              initialValue: _donor!.nationalId,
              decoration: const InputDecoration(
                labelText: 'National ID',
                prefixIcon: Icon(Icons.badge_outlined),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Blood group: '),
                BloodGroupChip(group: _donor!.bloodGroup.label),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _fullNameController,
              decoration: const InputDecoration(labelText: 'Full name *'),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Date of birth *'),
              subtitle: Text(
                _dateOfBirth == null
                    ? 'Select date'
                    : '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}',
              ),
              trailing: const Icon(Icons.calendar_today_outlined),
              onTap: _pickDateOfBirth,
            ),
            const SizedBox(height: 8),
            SegmentedButton<Gender>(
              segments: const [
                ButtonSegment(value: Gender.male, label: Text('Male')),
                ButtonSegment(value: Gender.female, label: Text('Female')),
              ],
              selected: {_gender},
              onSelectionChanged: (s) => setState(() => _gender = s.first),
            ),
            const SizedBox(height: 16),
            PhoneNumberFieldList(
              phones: _phones,
              onChanged: (phones) => setState(() => _phones = phones),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _streetController,
              decoration: const InputDecoration(labelText: 'Street'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _areaController,
              decoration: const InputDecoration(labelText: 'Area'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: 'City'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _postalController,
              decoration: const InputDecoration(labelText: 'Postal code'),
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
                  : const Text('Save changes'),
            ),
          ],
        ),
      ),
    );
  }
}
