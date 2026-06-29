import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:frontend/core/providers/auth_controller.dart';
import 'package:frontend/core/providers/theme_controller.dart';
import 'package:frontend/core/router/app_router.dart';
import 'package:frontend/core/services/app_preferences.dart';
import 'package:frontend/core/theme/app_theme.dart';
import 'package:frontend/data/mock/mock_auth_repository.dart';
import 'package:frontend/data/mock/mock_branch_repository.dart';
import 'package:frontend/data/mock/mock_donation_repository.dart';
import 'package:frontend/data/mock/mock_donor_repository.dart';
import 'package:frontend/data/mock/mock_inventory_repository.dart';
import 'package:frontend/data/mock/mock_payment_repository.dart';
import 'package:frontend/data/mock/mock_report_repository.dart';
import 'package:frontend/data/mock/mock_request_repository.dart';
import 'package:frontend/data/mock/mock_fulfillment_repository.dart';
import 'package:frontend/data/mock/mock_transport_repository.dart';
import 'package:frontend/data/mock/mock_user_repository.dart';
import 'package:frontend/data/repositories/auth_repository.dart';
import 'package:frontend/data/repositories/branch_repository.dart';
import 'package:frontend/data/repositories/donation_repository.dart';
import 'package:frontend/data/repositories/donor_repository.dart';
import 'package:frontend/data/repositories/inventory_repository.dart';
import 'package:frontend/data/repositories/payment_repository.dart';
import 'package:frontend/data/repositories/fulfillment_repository.dart';
import 'package:frontend/data/repositories/report_repository.dart';
import 'package:frontend/data/repositories/request_repository.dart';
import 'package:frontend/data/mock/mock_screening_repository.dart';
import 'package:frontend/data/repositories/screening_repository.dart';
import 'package:frontend/data/repositories/transport_repository.dart';
import 'package:frontend/data/repositories/user_repository.dart';

class BloodLinkApp extends StatefulWidget {
  const BloodLinkApp({super.key});

  @override
  State<BloodLinkApp> createState() => _BloodLinkAppState();
}

class _BloodLinkAppState extends State<BloodLinkApp> {
  MockAuthRepository? _authRepository;
  AuthController? _authController;
  ThemeController? _themeController;
  AppPreferences? _prefs;
  GoRouter? _router;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final prefs = await AppPreferences.create();
    final authRepo = MockAuthRepository();
    final authController = AuthController(authRepo);
    final themeController = ThemeController();
    final router = createAppRouter(authController, themeController);
    setState(() {
      _prefs = prefs;
      _authRepository = authRepo;
      _authController = authController;
      _themeController = themeController;
      _router = router;
      _ready = true;
    });
  }

  @override
  void dispose() {
    _router?.dispose();
    _authController?.dispose();
    _themeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MultiProvider(
      providers: [
        Provider<AppPreferences>.value(value: _prefs!),
        Provider<AuthRepository>.value(value: _authRepository!),
        Provider<DonorRepository>(create: (_) => MockDonorRepository()),
        Provider<DonationRepository>(create: (_) => MockDonationRepository()),
        Provider<ScreeningRepository>(create: (_) => MockScreeningRepository()),
        Provider<InventoryRepository>(create: (_) => MockInventoryRepository()),
        Provider<RequestRepository>(create: (_) => MockRequestRepository()),
        Provider<TransportRepository>(create: (_) => MockTransportRepository()),
        Provider<AllocationRepository>(create: (_) => MockAllocationRepository()),
        Provider<FulfillmentRepository>(
          create: (context) => MockFulfillmentRepository(
            context.read<InventoryRepository>(),
            context.read<TransportRepository>(),
            context.read<AllocationRepository>(),
          ),
        ),
        Provider<BranchRepository>(create: (_) => MockBranchRepository()),
        Provider<UserRepository>(create: (_) => MockUserRepository()),
        Provider<ReportRepository>(create: (_) => MockReportRepository()),
        Provider<PaymentRepository>(create: (_) => MockPaymentRepository()),
        ChangeNotifierProvider<AuthController>.value(value: _authController!),
        ChangeNotifierProvider<ThemeController>.value(value: _themeController!),
      ],
      child: AnimatedBuilder(
        animation: _themeController!,
        builder: (context, _) {
          return MaterialApp.router(
            title: 'BloodLink',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: _themeController!.mode,
            routerConfig: _router!,
          );
        },
      ),
    );
  }
}
