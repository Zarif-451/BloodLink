import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:frontend/core/constants/strings.dart';
import 'package:frontend/core/providers/auth_controller.dart';
import 'package:frontend/core/providers/theme_controller.dart';
import 'package:frontend/core/router/app_routes.dart';

class StaffMoreScreen extends StatelessWidget {
  const StaffMoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'More',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        _MoreTile(
          icon: Icons.bloodtype_outlined,
          title: 'Record donation',
          subtitle: 'Select donor and log donation',
          onTap: () => context.push(AppRoutes.staffSelectDonor),
        ),
        _MoreTile(
          icon: Icons.local_shipping_outlined,
          title: 'Transports',
          subtitle: 'Phase 4 — inter-branch transport',
          onTap: () => context.push(AppRoutes.staffTransports),
        ),
        const Divider(height: 24),
        _MoreTile(
          icon: isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          title: isDark ? 'Light mode' : 'Dark mode',
          subtitle: 'Appearance',
          onTap: () => context.read<ThemeController>().toggle(),
        ),
        _MoreTile(
          icon: Icons.logout,
          title: AppStrings.signOut,
          onTap: () async {
            await context.read<AuthController>().logout();
            if (context.mounted) context.go(AppRoutes.login);
          },
        ),
      ],
    );
  }
}

class _MoreTile extends StatelessWidget {
  const _MoreTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
