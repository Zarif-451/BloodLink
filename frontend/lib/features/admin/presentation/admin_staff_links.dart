import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/core/router/app_routes.dart';

/// Staff flows reused by Admin — single source for Operations hub + dashboard shortcuts.
class AdminStaffLink {
  const AdminStaffLink({
    required this.title,
    required this.route,
    required this.icon,
    this.subtitle,
    this.section,
  });

  final String title;
  final String route;
  final IconData icon;
  final String? subtitle;
  final String? section;
}

const adminStaffLinks = [
  AdminStaffLink(
    section: 'Supply',
    title: 'Donors',
    subtitle: 'Register, search, donation history',
    route: AppRoutes.staffDonors,
    icon: Icons.people_outline,
  ),
  AdminStaffLink(
    section: 'Supply',
    title: 'Record donation',
    subtitle: 'Select donor and log units',
    route: AppRoutes.staffSelectDonor,
    icon: Icons.bloodtype_outlined,
  ),
  AdminStaffLink(
    section: 'Supply',
    title: 'Inventory',
    subtitle: 'Branch stock and unit status',
    route: AppRoutes.staffInventory,
    icon: Icons.inventory_2_outlined,
  ),
  AdminStaffLink(
    section: 'Demand',
    title: 'Requests',
    subtitle: 'Approve, reject, allocate blood',
    route: AppRoutes.staffRequests,
    icon: Icons.pending_actions_outlined,
  ),
  AdminStaffLink(
    section: 'Demand',
    title: 'Transports',
    subtitle: 'Inter-branch delivery tracking',
    route: AppRoutes.staffTransports,
    icon: Icons.local_shipping_outlined,
  ),
];

void openAdminStaffFlow(BuildContext context, String route) {
  context.push(route);
}
