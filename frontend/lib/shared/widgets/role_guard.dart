import 'package:flutter/material.dart';

class RoleGuard extends StatelessWidget {
  final List<String> allowedRoles;
  final String currentRole;
  final Widget child;
  final Widget? fallback;

  const RoleGuard({
    super.key,
    required this.allowedRoles,
    required this.currentRole,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    if (allowedRoles.contains(currentRole)) {
      return child;
    }
    return fallback ?? const SizedBox.shrink();
  }
}