import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/core/auth/role_permissions.dart';
import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/core/providers/auth_controller.dart';
import 'package:frontend/core/providers/theme_controller.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/shell/app_shells.dart';
import 'package:frontend/core/widgets/placeholder_screen.dart';
import 'package:frontend/features/admin/presentation/admin_operations_screen.dart';
import 'package:frontend/features/admin/presentation/admin_tab_screens.dart';
import 'package:frontend/features/auth/presentation/forgot_password_screen.dart';
import 'package:frontend/features/auth/presentation/login_screen.dart';
import 'package:frontend/features/auth/presentation/onboarding_screen.dart';
import 'package:frontend/features/auth/presentation/splash_screen.dart';
import 'package:frontend/features/public/presentation/payment_screen.dart';
import 'package:frontend/features/public/presentation/request_blood_screen.dart';
import 'package:frontend/features/public/presentation/request_submitted_screen.dart';
import 'package:frontend/features/public/presentation/request_status_screen.dart';
import 'package:frontend/features/public/presentation/track_request_screen.dart';
import 'package:frontend/features/staff/donations/presentation/donation_detail_screen.dart';
import 'package:frontend/features/staff/donations/presentation/record_donation_screen.dart';
import 'package:frontend/features/staff/donations/presentation/screening_form_screen.dart';
import 'package:frontend/features/staff/donations/presentation/select_donor_screen.dart';
import 'package:frontend/features/staff/donors/presentation/donor_detail_screen.dart';
import 'package:frontend/features/staff/donors/presentation/donor_donation_history_screen.dart';
import 'package:frontend/features/staff/donors/presentation/donors_list_screen.dart';
import 'package:frontend/features/staff/donors/presentation/edit_donor_screen.dart';
import 'package:frontend/features/staff/donors/presentation/register_donor_screen.dart';
import 'package:frontend/features/staff/inventory/presentation/add_inventory_screen.dart';
import 'package:frontend/features/staff/inventory/presentation/inventory_detail_screen.dart';
import 'package:frontend/features/staff/inventory/presentation/inventory_list_screen.dart';
import 'package:frontend/features/staff/presentation/staff_dashboard_screen.dart';
import 'package:frontend/features/staff/presentation/staff_more_screen.dart';
import 'package:frontend/features/staff/requests/presentation/allocate_blood_screen.dart';
import 'package:frontend/features/staff/requests/presentation/request_detail_screen.dart';
import 'package:frontend/features/staff/requests/presentation/requests_queue_screen.dart';
import 'package:frontend/features/staff/transports/presentation/create_transport_screen.dart';
import 'package:frontend/features/staff/transports/presentation/transport_detail_screen.dart';
import 'package:frontend/features/staff/transports/presentation/transports_list_screen.dart';
import 'package:frontend/features/superadmin/presentation/branch_form_screen.dart';
import 'package:frontend/features/superadmin/presentation/branch_inventory_screen.dart';
import 'package:frontend/features/superadmin/presentation/branches_list_screen.dart';
import 'package:frontend/features/superadmin/presentation/cross_branch_inventory_screen.dart';
import 'package:frontend/features/superadmin/presentation/superadmin_operations_screen.dart';
import 'package:frontend/features/superadmin/presentation/system_dashboard_screen.dart';
import 'package:frontend/features/superadmin/presentation/system_reports_screen.dart';
import 'package:frontend/features/superadmin/presentation/system_requests_screen.dart';
import 'package:frontend/features/superadmin/presentation/system_transports_screen.dart';
import 'package:frontend/features/superadmin/presentation/user_form_screen.dart';
import 'package:frontend/features/superadmin/presentation/users_list_screen.dart';
import 'package:frontend/theme_preview/theme_preview_screen.dart';

GoRouter createAppRouter(AuthController auth, ThemeController theme) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: auth,
    redirect: (context, state) {
      final path = state.matchedLocation;
      final isAuthFlow = path == AppRoutes.splash ||
          path == AppRoutes.onboarding ||
          path == AppRoutes.login ||
          path == AppRoutes.forgotPassword;
      final isPublic = path.startsWith('/public');
      final isDev = path == AppRoutes.devTheme;

      if (isDev && !kDebugMode) return AppRoutes.login;
      if (isPublic || isDev) return null;

      if (path == AppRoutes.splash) {
        if (auth.isLoggedIn) {
          return auth.homeRouteForRole(auth.user!.role);
        }
        return null;
      }

      if (!auth.isLoggedIn && !isAuthFlow) return AppRoutes.login;

      if (auth.isLoggedIn &&
          (path == AppRoutes.login || path == AppRoutes.onboarding)) {
        return auth.homeRouteForRole(auth.user!.role);
      }

      if (auth.isLoggedIn) {
        final role = auth.user!.role;
        if (path.startsWith('/staff')) {
          if (!canAccessSharedStaffFlows(role)) {
            return auth.homeRouteForRole(role);
          }
          if (role == UserRole.admin &&
              (path == AppRoutes.staffHome || path == AppRoutes.staffMore)) {
            return AppRoutes.adminHome;
          }
          if (role == UserRole.superadmin && isStaffShellTabRoute(path)) {
            return AppRoutes.superadminHome;
          }
        }
        if (path.startsWith('/admin') && !canAccessAdminRoutes(role)) {
          return auth.homeRouteForRole(role);
        }
        if (path.startsWith('/superadmin') &&
            !canAccessSuperadminRoutes(role)) {
          return auth.homeRouteForRole(role);
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.staffSelectDonor,
        builder: (context, state) => const SelectDonorScreen(),
      ),
      GoRoute(
        path: AppRoutes.staffRecordDonation,
        builder: (context, state) {
          final nationalId = state.uri.queryParameters['nationalId'];
          if (nationalId == null || nationalId.isEmpty) {
            return const SelectDonorScreen();
          }
          return RecordDonationScreen(nationalId: nationalId);
        },
      ),
      GoRoute(
        path: '/staff/donations/:donationId',
        builder: (context, state) => DonationDetailScreen(
          donationId: int.parse(state.pathParameters['donationId']!),
        ),
        routes: [
          GoRoute(
            path: 'screening',
            builder: (context, state) => ScreeningFormScreen(
              donationId: int.parse(state.pathParameters['donationId']!),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/staff/requests/:requestId',
        builder: (context, state) => RequestDetailScreen(
          requestId: int.parse(state.pathParameters['requestId']!),
        ),
        routes: [
          GoRoute(
            path: 'allocate',
            builder: (context, state) => AllocateBloodScreen(
              requestId: int.parse(state.pathParameters['requestId']!),
              fulfillingBranchId: int.tryParse(
                state.uri.queryParameters['branchId'] ?? '',
              ),
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.staffTransports,
        builder: (context, state) => const TransportsListScreen(),
        routes: [
          GoRoute(
            path: 'new',
            builder: (context, state) => const CreateTransportScreen(),
          ),
          GoRoute(
            path: ':transportId',
            builder: (context, state) => TransportDetailScreen(
              transportId: int.parse(state.pathParameters['transportId']!),
            ),
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            StaffShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.staffHome,
                builder: (context, state) => const StaffDashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.staffDonors,
                builder: (context, state) => const DonorsListScreen(),
                routes: [
                  GoRoute(
                    path: 'register',
                    builder: (context, state) => RegisterDonorScreen(
                      returnToDonation:
                          state.uri.queryParameters['return'] == 'donation',
                    ),
                  ),
                  GoRoute(
                    path: ':nationalId',
                    builder: (context, state) => DonorDetailScreen(
                      nationalId: state.pathParameters['nationalId']!,
                    ),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        builder: (context, state) => EditDonorScreen(
                          nationalId: state.pathParameters['nationalId']!,
                        ),
                      ),
                      GoRoute(
                        path: 'history',
                        builder: (context, state) =>
                            DonorDonationHistoryScreen(
                          nationalId: state.pathParameters['nationalId']!,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.staffInventory,
                builder: (context, state) => const InventoryListScreen(),
                routes: [
                  GoRoute(
                    path: 'add',
                    builder: (context, state) {
                      final id = int.tryParse(
                            state.uri.queryParameters['donationId'] ?? '',
                          ) ??
                          0;
                      return AddInventoryScreen(donationId: id);
                    },
                  ),
                  GoRoute(
                    path: ':inventoryId',
                    builder: (context, state) => InventoryDetailScreen(
                      inventoryId:
                          int.parse(state.pathParameters['inventoryId']!),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.staffRequests,
                builder: (context, state) => const RequestsQueueScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.staffMore,
                builder: (context, state) => const StaffMoreScreen(),
              ),
            ],
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AdminShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.adminHome,
                builder: (context, state) => const AdminDashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.adminOperations,
                builder: (context, state) => const AdminOperationsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.adminReports,
                builder: (context, state) => const AdminReportsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.adminSettings,
                builder: (context, state) => const AdminSettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      ShellRoute(
        builder: (context, state, child) => SuperadminShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.superadminHome,
            builder: (context, state) => const SystemDashboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.superadminOperations,
            builder: (context, state) => const SuperadminOperationsScreen(),
          ),
          GoRoute(
            path: AppRoutes.superadminBranches,
            builder: (context, state) => const BranchesListScreen(),
          ),
          GoRoute(
            path: AppRoutes.superadminUsers,
            builder: (context, state) => const UsersListScreen(),
          ),
          GoRoute(
            path: AppRoutes.superadminInventory,
            builder: (context, state) => const CrossBranchInventoryScreen(),
          ),
          GoRoute(
            path: AppRoutes.superadminRequests,
            builder: (context, state) => const SystemRequestsScreen(),
          ),
          GoRoute(
            path: AppRoutes.superadminReports,
            builder: (context, state) => const SystemReportsScreen(),
          ),
          GoRoute(
            path: AppRoutes.superadminTransports,
            builder: (context, state) => const SystemTransportsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.superadminBranchNew,
        builder: (context, state) => const BranchFormScreen(),
      ),
      GoRoute(
        path: '/superadmin/branches/:branchId/edit',
        builder: (context, state) => BranchFormScreen(
          branchId: int.parse(state.pathParameters['branchId']!),
        ),
      ),
      GoRoute(
        path: AppRoutes.superadminUserNew,
        builder: (context, state) => const UserFormScreen(),
      ),
      GoRoute(
        path: '/superadmin/users/:userId/edit',
        builder: (context, state) => UserFormScreen(
          userId: int.parse(state.pathParameters['userId']!),
        ),
      ),
      GoRoute(
        path: '/superadmin/inventory/:branchId',
        builder: (context, state) => BranchInventoryScreen(
          branchId: int.parse(state.pathParameters['branchId']!),
        ),
      ),
      GoRoute(
        path: AppRoutes.publicRequest,
        builder: (context, state) => const RequestBloodScreen(),
      ),
      GoRoute(
        path: AppRoutes.publicRequestSuccess,
        builder: (context, state) {
          final params = state.uri.queryParameters;
          final id = int.tryParse(params['id'] ?? '') ?? 0;
          return RequestSubmittedScreen(
            requestId: id,
            bloodGroup: params['group'] ?? '',
            quantity: int.tryParse(params['qty'] ?? '') ?? 1,
            urgency: params['urgency'] ?? 'Normal',
          );
        },
      ),
      GoRoute(
        path: AppRoutes.publicTrack,
        builder: (context, state) => const TrackRequestScreen(),
      ),
      GoRoute(
        path: '/public/track/:id',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          if (id == null) {
            return const TrackRequestScreen();
          }
          return RequestStatusScreen(requestId: id);
        },
      ),
      GoRoute(
        path: '/public/payment/:paymentId',
        builder: (context, state) => PaymentScreen(
          paymentId: int.parse(state.pathParameters['paymentId']!),
        ),
      ),
      if (kDebugMode)
        GoRoute(
          path: AppRoutes.devTheme,
          builder: (context, state) => ThemePreviewScreen(
            themeMode: theme.isDark ? ThemeMode.dark : ThemeMode.light,
            onThemeModeChanged: (mode) => theme.setMode(mode),
          ),
        ),
      GoRoute(
        path: '/placeholder/:title',
        builder: (context, state) => PlaceholderScreen(
          title: state.pathParameters['title'] ?? 'Coming soon',
        ),
      ),
    ],
  );
}
