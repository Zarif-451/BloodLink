import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/widgets/widgets.dart';
import 'package:frontend/data/mock/mock_data.dart';
import 'package:frontend/data/models/user.dart';
import 'package:frontend/data/repositories/user_repository.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  List<AppUser> _users = [];
  bool _loading = true;
  int? _branchFilter;
  UserRole? _roleFilter;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final list = await context.read<UserRepository>().getUsers(
          branchId: _branchFilter,
          role: _roleFilter,
        );
    if (!mounted) return;
    setState(() {
      _users = list;
      _loading = false;
    });
  }

  String _branchName(int id) {
    try {
      return MockData.branches.firstWhere((b) => b.id == id).name;
    } catch (_) {
      return 'Branch $id';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: FilledButton.icon(
              onPressed: () => context.push(AppRoutes.superadminUserNew),
              icon: const Icon(Icons.person_add_outlined),
              label: const Text('Add user'),
            ),
          ),
        ),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All branches'),
                  selected: _branchFilter == null,
                  onSelected: (_) {
                    setState(() => _branchFilter = null);
                    _load();
                  },
                ),
                const SizedBox(width: 8),
                for (final b in MockData.branches)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(b.name.split('·').last.trim()),
                      selected: _branchFilter == b.id,
                      onSelected: (_) {
                        setState(() => _branchFilter = b.id);
                        _load();
                      },
                    ),
                  ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All roles'),
                  selected: _roleFilter == null,
                  onSelected: (_) {
                    setState(() => _roleFilter = null);
                    _load();
                  },
                ),
                const SizedBox(width: 8),
                for (final r in [UserRole.staff, UserRole.admin, UserRole.superadmin])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(r.label),
                      selected: _roleFilter == r,
                      onSelected: (_) {
                        setState(() => _roleFilter = r);
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
                : _users.isEmpty
                    ? const EmptyState(
                        message: 'No users match filters',
                        icon: Icons.group_outlined,
                      )
                    : RefreshIndicator(
                        onRefresh: _load,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _users.length,
                          itemBuilder: (context, index) {
                            final user = _users[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: ListTile(
                                title: Text(user.fullName),
                                subtitle: Text(
                                  '${user.email}\n${_branchName(user.branchId)} · ${user.role.label}',
                                ),
                                isThreeLine: true,
                                trailing: StatusPill(
                                  label: user.status.label,
                                  tone: user.status == UserStatus.active
                                      ? StatusTone.success
                                      : StatusTone.neutral,
                                ),
                                onTap: () => context.push(
                                  AppRoutes.superadminUserEdit(user.id),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      );
  }
}
