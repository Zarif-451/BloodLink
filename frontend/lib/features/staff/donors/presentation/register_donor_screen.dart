import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/widgets/phone_number_field_list.dart';
import 'package:frontend/data/models/donor.dart';
import 'package:frontend/data/repositories/donor_repository.dart';
import 'package:frontend/features/staff/donors/presentation/donor_utils.dart';

class RegisterDonorScreen extends StatefulWidget {
  const RegisterDonorScreen({super.key, this.returnToDonation = false});

  final bool returnToDonation;

  @override
  State<RegisterDonorScreen> createState() => _RegisterDonorScreenState();
}

class _RegisterDonorScreenState extends State<RegisterDonorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nationalIdController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _streetController = TextEditingController();
  final _areaController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalController = TextEditingController();

  DateTime? _dateOfBirth;
  Gender _gender = Gender.male;
  BloodGroup _bloodGroup = BloodGroup.oPositive;
  List<String> _phones = [''];
  bool _saving = false;

  @override
  void dispose() {
    _nationalIdController.dispose();
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
      initialDate: DateTime(2000),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _dateOfBirth = picked);
  }

  Future<void> _save({bool andDonate = false}) async {
    if (!_formKey.currentState!.validate()) return;
    if (_dateOfBirth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Date of birth is required')),
      );
      return;
    }

    if (_dateOfBirth == null || !isDonorAdult(_dateOfBirth!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Donor must be 18 or older')),
      );
      return;
    }

    setState(() => _saving = true);
    final repo = context.read<DonorRepository>();
    final nationalId = _nationalIdController.text.trim();
    final existing = await repo.getDonor(nationalId);
    if (!mounted) return;

    if (existing != null) {
      setState(() => _saving = false);
      final view = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Donor already registered'),
          content: const Text(
            'A donor with this National ID already exists.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('View existing donor'),
            ),
          ],
        ),
      );
      if (view == true && mounted) {
        context.go(AppRoutes.staffDonorDetail(nationalId));
      }
      return;
    }

    final phones = _phones.where((p) => p.trim().isNotEmpty).toList();
    final donor = Donor(
      nationalId: nationalId,
      fullName: _fullNameController.text.trim(),
      bloodGroup: _bloodGroup,
      dateOfBirth: _dateOfBirth!,
      gender: _gender,
      street: _streetController.text.trim(),
      area: _areaController.text.trim(),
      city: _cityController.text.trim(),
      postalCode: _postalController.text.trim(),
      phones: phones,
    );

    await repo.createDonor(donor);
    if (!mounted) return;
    setState(() => _saving = false);

    if (andDonate || widget.returnToDonation) {
      context.go(
        '${AppRoutes.staffRecordDonation}?nationalId=${Uri.encodeComponent(nationalId)}',
      );
    } else {
      context.go(AppRoutes.staffDonorDetail(nationalId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register donor')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Identity', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nationalIdController,
              decoration: const InputDecoration(
                labelText: 'National ID *',
                prefixIcon: Icon(Icons.badge_outlined),
              ),
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
                if (!isValidNationalId(v.trim())) {
                  return 'Enter 10, 13, or 17 digit NID';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _fullNameController,
              decoration: const InputDecoration(
                labelText: 'Full name *',
                prefixIcon: Icon(Icons.person_outline),
              ),
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
            if (_dateOfBirth != null && !isDonorAdult(_dateOfBirth!))
              Text(
                'Donor must be 18 or older',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
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
            const SizedBox(height: 12),
            DropdownButtonFormField<BloodGroup>(
              initialValue: _bloodGroup,
              decoration: const InputDecoration(labelText: 'Blood group *'),
              items: [
                for (final g in BloodGroup.values)
                  DropdownMenuItem(value: g, child: Text(g.label)),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _bloodGroup = v);
              },
            ),
            const SizedBox(height: 24),
            Text('Contact', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            PhoneNumberFieldList(
              phones: _phones,
              onChanged: (phones) => setState(() => _phones = phones),
            ),
            const SizedBox(height: 24),
            Text('Address', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
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
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _saving ? null : () => context.pop(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _saving ? null : () => _save(),
                    child: _saving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _saving ? null : () => _save(andDonate: true),
              child: const Text('Save & record donation'),
            ),
          ],
        ),
      ),
    );
  }
}
