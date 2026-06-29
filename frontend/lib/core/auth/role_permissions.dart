import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/core/router/app_routes.dart';

/// Staff / Admin bottom-nav tab routes inside [StaffShell].
bool isStaffShellTabRoute(String path) =>
    path == AppRoutes.staffHome ||
    path == AppRoutes.staffDonors ||
    path == AppRoutes.staffInventory ||
    path == AppRoutes.staffRequests ||
    path == AppRoutes.staffMore;

/// Which roles may open Staff shell tabs (`/staff`, `/staff/donors`, …).
bool canAccessStaffShellRoutes(UserRole role) =>
    role == UserRole.staff || role == UserRole.admin;

/// Staff + Admin + Superadmin may open shared Staff **flow** routes
/// (request detail, allocate, transports, donations, nested detail).
bool canAccessSharedStaffFlows(UserRole role) =>
    role == UserRole.staff ||
    role == UserRole.admin ||
    role == UserRole.superadmin;

/// @deprecated Use [canAccessStaffShellRoutes] or [canAccessSharedStaffFlows].
bool canAccessStaffRoutes(UserRole role) => canAccessStaffShellRoutes(role);

/// Admin-only routes (`/admin/*`).
bool canAccessAdminRoutes(UserRole role) => role == UserRole.admin;

/// Superadmin system routes (`/superadmin/*`).
bool canAccessSuperadminRoutes(UserRole role) =>
    role == UserRole.superadmin;

/// Cross-branch / system-wide management (branches, users, system KPIs).
bool canManageAllBranches(UserRole role) => role == UserRole.superadmin;
