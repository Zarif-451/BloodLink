import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/core/providers/auth_controller.dart';

/// Shows [child] only when the logged-in user has one of [allowedRoles].
class RoleGate extends StatelessWidget {
  const RoleGate({
    super.key,
    required this.allowedRoles,
    required this.child,
    this.fallback = const SizedBox.shrink(),
  });

  final Set<UserRole> allowedRoles;
  final Widget child;
  final Widget fallback;

  @override
  Widget build(BuildContext context) {
    final role = context.watch<AuthController>().user?.role;
    if (role != null && allowedRoles.contains(role)) {
      return child;
    }
    return fallback;
  }
}
