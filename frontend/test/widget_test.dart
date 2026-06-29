import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:frontend/app.dart';
import 'package:frontend/core/constants/strings.dart';
import 'package:frontend/data/mock/mock_data.dart';
import 'package:frontend/data/mock/mock_donor_repository.dart';

Future<void> _pumpUntilLogin(WidgetTester tester) async {
  await tester.pumpWidget(const BloodLinkApp());
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
  await tester.pump(const Duration(milliseconds: 1000));
  await tester.pump(const Duration(milliseconds: 500));
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({'onboarding_complete': true});
    MockData.loggedInUser = null;
  });

  testWidgets('App launches to login', (WidgetTester tester) async {
    await _pumpUntilLogin(tester);
    expect(find.text('Sign in to ${AppStrings.appName}'), findsOneWidget);
    expect(find.text(AppStrings.signIn), findsOneWidget);
  });

  test('Mock donor repository returns seed data', () async {
    final repo = MockDonorRepository();
    final donors = await repo.getDonors();
    expect(donors.length, greaterThanOrEqualTo(5));
  });

  testWidgets('Login navigates to staff shell dashboard', (WidgetTester tester) async {
    await _pumpUntilLogin(tester);

    await tester.tap(find.text(AppStrings.signIn));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 800));

    expect(find.text('Dashboard'), findsWidgets);
    expect(find.text('Pending requests'), findsOneWidget);
  });

  testWidgets('Login navigates to admin shell dashboard', (WidgetTester tester) async {
    await _pumpUntilLogin(tester);

    await tester.enterText(find.text('staff@cuet.edu.bd'), 'admin@cuet.edu.bd');
    await tester.tap(find.text(AppStrings.signIn));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 800));

    expect(find.text('Admin dashboard'), findsWidgets);
    expect(find.text('Operations'), findsOneWidget);
  });

  testWidgets('Login navigates to superadmin system dashboard', (WidgetTester tester) async {
    await _pumpUntilLogin(tester);

    await tester.enterText(find.text('staff@cuet.edu.bd'), 'super@cuet.edu.bd');
    await tester.tap(find.text(AppStrings.signIn));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 800));

    expect(find.text('BloodLink System'), findsOneWidget);
    expect(find.text('System overview'), findsOneWidget);
    expect(find.text('Open requests'), findsOneWidget);
  });
}
