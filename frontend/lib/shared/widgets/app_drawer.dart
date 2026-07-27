import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../shared/providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final role = context.watch<AuthProvider>().role ?? '';
    final userName = context.watch<AuthProvider>().fullName ?? 'User';
    final userEmail = context.watch<AuthProvider>().email ?? '';

    return NavigationDrawer(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                userName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                userEmail,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              StatusBadge(status: role),
            ],
          ),
        ),
        _buildItem(
          context,
          icon: Icons.dashboard_outlined,
          label: 'Dashboard',
          route: '/dashboard',
        ),
        if (['SuperAdmin', 'Admin'].contains(role))
          _buildItem(
            context,
            icon: Icons.people_outline,
            label: 'Users',
            route: '/users',
          ),
        _buildItem(
          context,
          icon: Icons.volunteer_activism,
          label: 'Donors',
          route: '/donors',
        ),
        _buildItem(
          context,
          icon: Icons.bloodtype_outlined,
          label: 'Donations',
          route: '/donations',
        ),
        _buildItem(
          context,
          icon: Icons.biotech_outlined,
          label: 'Screenings',
          route: '/screenings',
        ),
        _buildItem(
          context,
          icon: Icons.inventory_2_outlined,
          label: 'Inventory',
          route: '/inventory',
        ),
        _buildItem(
          context,
          icon: Icons.assignment_outlined,
          label: 'Requests',
          route: '/requests',
        ),
        _buildItem(
          context,
          icon: Icons.compare_arrows,
          label: 'Allocations',
          route: '/allocations',
        ),
        if (role == 'SuperAdmin')
          _buildItem(
            context,
            icon: Icons.business_outlined,
            label: 'Branches',
            route: '/branches',
          ),
        _buildItem(
          context,
          icon: Icons.local_shipping_outlined,
          label: 'Transport',
          route: '/transport',
        ),
        _buildItem(
          context,
          icon: Icons.payment_outlined,
          label: 'Payments',
          route: '/payments',
        ),
        if (['SuperAdmin', 'Admin'].contains(role))
          _buildItem(
            context,
            icon: Icons.assessment_outlined,
            label: 'Reports',
            route: '/reports',
          ),
        const Divider(),
        _buildItem(
          context,
          icon: Icons.logout,
          label: 'Logout',
          onTap: () {
            context.read<AuthProvider>().logout();
            context.go('/login');
          },
        ),
      ],
    );
  }

  Widget _buildItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    String? route,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        onTap: onTap ??
            (route != null ? () => context.go(route) : null),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}