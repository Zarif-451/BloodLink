import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/core/providers/auth_controller.dart';
import 'package:frontend/data/mock/mock_data.dart';
import 'package:frontend/data/models/user.dart';
import 'package:frontend/data/repositories/user_repository.dart';

class UserFormScreen extends StatefulWidget {
  const UserFormScreen({super.key, this.userId});

  final int? userId;

  bool get isEdit => userId != null;

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  int _branchId = MockData.dhakaBranchId;
  UserRole _role = UserRole.staff;
  UserStatus _status = UserStatus.active;
  bool _loading = true;
  bool _saving = false;
  AppUser? _existing;

  bool get _isSelf =>
      _existing != null &&
      _existing!.id == context.read<AuthController>().user?.id;

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
    final user = await context.read<UserRepository>().getUser(widget.userId!);
    if (!mounted) return;
    if (user == null) {
      context.pop();
      return;
    }
    _nameController.text = user.fullName;
    _emailController.text = user.email;
    setState(() {
      _existing = user;
      _branchId = user.branchId;
      _role = user.role;
      _status = user.status;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSelf && _role != UserRole.superadmin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You cannot demote your own superadmin role')),
      );
      return;
    }

    setState(() => _saving = true);
    final repo = context.read<UserRepository>();

    try {
      if (widget.isEdit) {
        await repo.updateUser(
          AppUser(
            id: widget.userId!,
            fullName: _nameController.text.trim(),
            email: _emailController.text.trim(),
            role: _role,
            branchId: _branchId,
            status: _status,
          ),
        );
      } else {
        await repo.createUser(
          AppUser(
            id: 0,
            fullName: _nameController.text.trim(),
            email: _emailController.text.trim(),
            role: _role,
            branchId: _branchId,
            status: _status,
          ),
        );
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.isEdit ? 'User updated' : 'User created')),
      );
      context.pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isEdit ? 'Edit user' : 'New user')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Full name *'),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email *'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      if (!v.contains('@')) return 'Invalid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    key: ValueKey(_branchId),
                    initialValue: _branchId,
                    decoration: const InputDecoration(labelText: 'Branch'),
                    items: [
                      for (final b in MockData.branches)
                        DropdownMenuItem(value: b.id, child: Text(b.name)),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _branchId = v);
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<UserRole>(
                    key: ValueKey(_role),
                    initialValue: _role,
                    decoration: const InputDecoration(labelText: 'Role'),
                    items: [
                      for (final r in UserRole.values)
                        DropdownMenuItem(
                          value: r,
                          enabled: !_isSelf || r == UserRole.superadmin,
                          child: Text(r.label),
                        ),
                    ],
                    onChanged: _isSelf
                        ? null
                        : (v) {
                            if (v != null) setState(() => _role = v);
                          },
                  ),
                  if (_isSelf)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Superadmin role cannot be changed on your own account.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<UserStatus>(
                    key: ValueKey(_status),
                    initialValue: _status,
                    decoration: const InputDecoration(labelText: 'Status'),
                    items: [
                      for (final s in UserStatus.values)
                        DropdownMenuItem(value: s, child: Text(s.label)),
                    ],
                    onChanged: _isSelf
                        ? null
                        : (v) {
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
                        : Text(widget.isEdit ? 'Save changes' : 'Create user'),
                  ),
                ],
              ),
            ),
    );
  }
}
