import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/data/mock/mock_data.dart';
import 'package:frontend/data/models/user.dart';
import 'package:frontend/data/repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  @override
  AppUser? get currentUser => MockData.loggedInUser;

  @override
  Future<LoginResult> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final match = MockData.users.where(
      (u) => u.email.toLowerCase() == email.toLowerCase(),
    );
    if (match.isEmpty || password.length < 6) {
      return const LoginResult.failure(LoginFailure.invalidCredentials);
    }
    final user = match.first;
    if (user.status != UserStatus.active) {
      return const LoginResult.failure(LoginFailure.accountSuspended);
    }
    MockData.loggedInUser = user;
    return LoginResult.success(user);
  }

  @override
  Future<void> logout() async {
    MockData.loggedInUser = null;
  }
}
