import 'package:frontend/data/models/user.dart';

enum LoginFailure { invalidCredentials, accountSuspended }

class LoginResult {
  const LoginResult.success(this.user) : failure = null;
  const LoginResult.failure(this.failure) : user = null;

  final AppUser? user;
  final LoginFailure? failure;

  bool get isSuccess => user != null;
}

abstract class AuthRepository {
  Future<LoginResult> login({required String email, required String password});
  Future<void> logout();
  AppUser? get currentUser;
}
