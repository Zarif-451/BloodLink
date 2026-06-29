import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/core/router/app_routes.dart';

class SuperadminFlowLink {
  const SuperadminFlowLink({
    required this.title,
    required this.route,
    required this.icon,
    this.subtitle,
    this.section,
    this.usePush = false,
  });

  final String title;
  final String route;
  final IconData icon;
  final String? subtitle;
  final String? section;
  final bool usePush;
}

/// Drawer destinations + shared Staff flows for the superadmin Operations hub.
const superadminFlowLinks = [
  SuperadminFlowLink(
    section: 'System',
    title: 'Branches',
    subtitle: 'All blood bank branches',
    route: AppRoutes.superadminBranches,
    icon: Icons.account_balance_outlined,
  ),
  SuperadminFlowLink(
    section: 'System',
    title: 'Users',
    subtitle: 'Staff and admin accounts',
    route: AppRoutes.superadminUsers,
    icon: Icons.group_outlined,
  ),
  SuperadminFlowLink(
    section: 'System',
    title: 'Cross-branch inventory',
    subtitle: 'Stock snapshot by branch',
    route: AppRoutes.superadminInventory,
    icon: Icons.inventory_2_outlined,
  ),
  SuperadminFlowLink(
    section: 'System',
    title: 'System reports',
    subtitle: 'Aggregate reports',
    route: AppRoutes.superadminReports,
    icon: Icons.assessment_outlined,
  ),
  SuperadminFlowLink(
    section: 'Fulfillment',
    title: 'All requests',
    subtitle: 'System-wide queue with branch picker on allocate',
    route: AppRoutes.superadminRequests,
    icon: Icons.pending_actions_outlined,
  ),
  SuperadminFlowLink(
    section: 'Fulfillment',
    title: 'System transports',
    subtitle: 'All branches — read-only system view',
    route: AppRoutes.superadminTransports,
    icon: Icons.local_shipping_outlined,
  ),
];

void openSuperadminFlow(BuildContext context, SuperadminFlowLink link) {
  if (link.usePush) {
    context.push(link.route);
  } else {
    context.go(link.route);
  }
}
