import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/data/models/branch.dart';
import 'package:frontend/data/repositories/branch_repository.dart';

class BranchFormScreen extends StatefulWidget {
  const BranchFormScreen({super.key, this.branchId});

  final int? branchId;

  bool get isEdit => branchId != null;

  @override
  State<BranchFormScreen> createState() => _BranchFormScreenState();
}

class _BranchFormScreenState extends State<BranchFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _districtController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();
  BranchStatus _status = BranchStatus.active;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      _load();
    } else {
      _loading = false;
    }
  }

  Future<void> _load() async {
    final branch =
        await context.read<BranchRepository>().getBranch(widget.branchId!);
    if (!mounted) return;
    if (branch == null) {
      context.pop();
      return;
    }
    _nameController.text = branch.name;
    _districtController.text = branch.district;
    _cityController.text = branch.city;
    _phoneController.text = branch.phones.isNotEmpty ? branch.phones.first : '';
    setState(() {
      _status = branch.status;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _districtController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final repo = context.read<BranchRepository>();
    final phones = _phoneController.text.trim().isEmpty
        ? <String>[]
        : [_phoneController.text.trim()];

    try {
      if (widget.isEdit) {
        await repo.updateBranch(
          Branch(
            id: widget.branchId!,
            name: _nameController.text.trim(),
            district: _districtController.text.trim(),
            city: _cityController.text.trim(),
            phones: phones,
            status: _status,
          ),
        );
      } else {
        await repo.createBranch(
          Branch(
            id: 0,
            name: _nameController.text.trim(),
            district: _districtController.text.trim(),
            city: _cityController.text.trim(),
            phones: phones,
            status: _status,
          ),
        );
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.isEdit ? 'Branch updated' : 'Branch created')),
      );
      context.pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit branch' : 'New branch'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Branch name *'),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _districtController,
                    decoration: const InputDecoration(labelText: 'District *'),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(labelText: 'City'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'Phone'),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<BranchStatus>(
                    key: ValueKey(_status),
                    initialValue: _status,
                    decoration: const InputDecoration(labelText: 'Status'),
                    items: [
                      for (final s in BranchStatus.values)
                        DropdownMenuItem(value: s, child: Text(s.label)),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _status = v);
                    },
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
                        : Text(widget.isEdit ? 'Save changes' : 'Create branch'),
                  ),
                ],
              ),
            ),
    );
  }
}
