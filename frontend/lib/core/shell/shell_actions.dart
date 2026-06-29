import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../constants/enums.dart';
import '../constants/strings.dart';
import '../providers/auth_controller.dart';
import '../providers/theme_controller.dart';
import '../router/app_routes.dart';

/// App bar overflow: theme toggle + sign out (staff/admin; superadmin has drawer logout too).
class ShellOverflowMenu extends StatelessWidget {
  const ShellOverflowMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final role = context.watch<AuthController>().user?.role;
    final location = GoRouterState.of(context).matchedLocation;
    final isAdminOnStaffFlow =
        role == UserRole.admin && location.startsWith('/staff');
    final isSuperadminOnStaffFlow =
        role == UserRole.superadmin && location.startsWith('/staff');

    return PopupMenuButton<String>(
      onSelected: (value) async {
        if (value == 'admin_home') {
          if (context.mounted) context.go(AppRoutes.adminHome);
        } else if (value == 'superadmin_home') {
          if (context.mounted) context.go(AppRoutes.superadminHome);
        } else if (value == 'theme') {
          context.read<ThemeController>().toggle();
        } else if (value == 'logout') {
          await context.read<AuthController>().logout();
          if (context.mounted) context.go(AppRoutes.login);
        } else if (value == 'theme_lab') {
          if (context.mounted) context.push(AppRoutes.devTheme);
        }
      },
      itemBuilder: (context) => [
        if (isAdminOnStaffFlow)
          const PopupMenuItem(
            value: 'admin_home',
            child: ListTile(
              leading: Icon(Icons.admin_panel_settings_outlined),
              title: Text('Admin dashboard'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        if (isSuperadminOnStaffFlow)
          const PopupMenuItem(
            value: 'superadmin_home',
            child: ListTile(
              leading: Icon(Icons.hub_outlined),
              title: Text('System dashboard'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        const PopupMenuItem(
          value: 'theme',
          child: ListTile(
            leading: Icon(Icons.dark_mode_outlined),
            title: Text('Toggle light / dark'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        if (kDebugMode)
          const PopupMenuItem(
            value: 'theme_lab',
            child: ListTile(
              leading: Icon(Icons.palette_outlined),
              title: Text('Theme lab'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        const PopupMenuItem(
          value: 'logout',
          child: ListTile(
            leading: Icon(Icons.logout),
            title: Text(AppStrings.signOut),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}
