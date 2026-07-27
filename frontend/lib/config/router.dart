import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../shared/providers/auth_provider.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static GoRouter create(AuthProvider authProvider) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/login',
      refreshListenable: authProvider,
      redirect: (context, state) {
        final isLoggedIn = authProvider.isAuthenticated;
        final isLoginRoute = state.matchedLocation == '/login';
        final isPublicRoute = state.matchedLocation == '/requests/public';

        if (!isLoggedIn && !isLoginRoute && !isPublicRoute) {
          return '/login';
        }
        if (isLoggedIn && isLoginRoute) {
          return '/dashboard';
        }
        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Login'))),
        ),
        GoRoute(
          path: '/requests/public',
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Submit Request'))),
        ),
        ShellRoute(
          builder: (context, state, child) => Scaffold(body: child),
          routes: [
            GoRoute(
              path: '/dashboard',
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Dashboard'))),
            ),
            GoRoute(
              path: '/users',
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Users'))),
            ),
            GoRoute(
              path: '/donors',
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Donors'))),
            ),
            GoRoute(
              path: '/donations',
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Donations'))),
            ),
            GoRoute(
              path: '/screenings',
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Screenings'))),
            ),
            GoRoute(
              path: '/inventory',
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Inventory'))),
            ),
            GoRoute(
              path: '/requests',
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Requests'))),
            ),
            GoRoute(
              path: '/allocations',
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Allocations'))),
            ),
            GoRoute(
              path: '/branches',
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Branches'))),
            ),
            GoRoute(
              path: '/transport',
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Transport'))),
            ),
            GoRoute(
              path: '/payments',
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Payments'))),
            ),
            GoRoute(
              path: '/reports',
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Reports'))),
            ),
          ],
        ),
      ],
    );
  }
}