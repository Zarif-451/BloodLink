import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../constants/enums.dart';
import '../providers/auth_controller.dart';
import '../router/app_routes.dart';
import '../widgets/role_badge.dart';
import 'shell_actions.dart';

class StaffShell extends StatelessWidget {
  const StaffShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _destinations = [
    NavigationDestination(
      icon: Icon(Icons.dashboard_outlined),
      selectedIcon: Icon(Icons.dashboard),
      label: 'Dashboard',
    ),
    NavigationDestination(
      icon: Icon(Icons.people_outline),
      selectedIcon: Icon(Icons.people),
      label: 'Donors',
    ),
    NavigationDestination(
      icon: Icon(Icons.inventory_2_outlined),
      selectedIcon: Icon(Icons.inventory_2),
      label: 'Inventory',
    ),
    NavigationDestination(
      icon: Icon(Icons.pending_actions_outlined),
      selectedIcon: Icon(Icons.pending_actions),
      label: 'Requests',
    ),
    NavigationDestination(
      icon: Icon(Icons.more_horiz),
      selectedIcon: Icon(Icons.more_horiz),
      label: 'More',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthController>().user;
    final titles = ['Dashboard', 'Donors', 'Inventory', 'Requests', 'More'];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[navigationShell.currentIndex]),
        actions: [
          if (user != null) RoleBadge(role: user.role),
          const ShellOverflowMenu(),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (user?.role == UserRole.admin)
            MaterialBanner(
              content: const Text('Admin — branch operations mode'),
              leading: const Icon(Icons.admin_panel_settings_outlined),
              actions: [
                TextButton(
                  onPressed: () => context.go(AppRoutes.adminHome),
                  child: const Text('Admin home'),
                ),
              ],
            ),
          if (user?.role == UserRole.superadmin)
            MaterialBanner(
              content: const Text('Superadmin — shared Staff flow'),
              leading: const Icon(Icons.hub_outlined),
              actions: [
                TextButton(
                  onPressed: () => context.go(AppRoutes.superadminHome),
                  child: const Text('System home'),
                ),
              ],
            ),
          Expanded(child: navigationShell),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: _destinations,
      ),
    );
  }
}

class AdminShell extends StatelessWidget {
  const AdminShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _destinations = [
    NavigationDestination(
      icon: Icon(Icons.dashboard_outlined),
      selectedIcon: Icon(Icons.dashboard),
      label: 'Dashboard',
    ),
    NavigationDestination(
      icon: Icon(Icons.medical_services_outlined),
      selectedIcon: Icon(Icons.medical_services),
      label: 'Operations',
    ),
    NavigationDestination(
      icon: Icon(Icons.assessment_outlined),
      selectedIcon: Icon(Icons.assessment),
      label: 'Reports',
    ),
    NavigationDestination(
      icon: Icon(Icons.settings_outlined),
      selectedIcon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthController>().user;
    final titles = ['Admin dashboard', 'Operations', 'Reports', 'Settings'];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[navigationShell.currentIndex]),
        actions: [
          if (user != null) RoleBadge(role: user.role),
          ShellOverflowMenu(),
        ],
      ),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: navigationShell.goBranch,
        destinations: _destinations,
      ),
    );
  }
}

class SuperadminShell extends StatelessWidget {
  const SuperadminShell({super.key, required this.child});

  final Widget child;

  static const _drawerItems = [
    (Icons.dashboard_outlined, 'Dashboard', AppRoutes.superadminHome),
    (Icons.hub_outlined, 'Operations', AppRoutes.superadminOperations),
    (Icons.account_balance_outlined, 'Branches', AppRoutes.superadminBranches),
    (Icons.group_outlined, 'Users', AppRoutes.superadminUsers),
    (Icons.inventory_2_outlined, 'Inventory', AppRoutes.superadminInventory),
    (Icons.pending_actions_outlined, 'Requests', AppRoutes.superadminRequests),
    (Icons.assessment_outlined, 'Reports', AppRoutes.superadminReports),
    (Icons.local_shipping_outlined, 'Transports', AppRoutes.superadminTransports),
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthController>().user;
    final location = GoRouterState.of(context).matchedLocation;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BloodLink System'),
        actions: [
          if (user != null) RoleBadge(role: user.role),
          ShellOverflowMenu(),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    user?.fullName ?? 'Superadmin',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    user?.email ?? '',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            for (final item in _drawerItems)
              ListTile(
                leading: Icon(item.$1),
                title: Text(item.$2),
                selected: location == item.$3,
                onTap: () {
                  Navigator.pop(context);
                  context.go(item.$3);
                },
              ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign out'),
              onTap: () async {
                Navigator.pop(context);
                await context.read<AuthController>().logout();
                if (context.mounted) context.go(AppRoutes.login);
              },
            ),
          ],
        ),
      ),
      body: child,
    );
  }
}
