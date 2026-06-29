import 'package:flutter/foundation.dart';
import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/data/models/user.dart';
import 'package:frontend/data/repositories/auth_repository.dart';

class AuthController extends ChangeNotifier {
  AuthController(this._repository);

  final AuthRepository _repository;
  LoginFailure? lastLoginFailure;

  AppUser? get user => _repository.currentUser;
  bool get isLoggedIn => user != null;

  Future<bool> login({required String email, required String password}) async {
    lastLoginFailure = null;
    final result =
        await _repository.login(email: email, password: password);
    if (result.isSuccess) {
      notifyListeners();
      return true;
    }
    lastLoginFailure = result.failure;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    await _repository.logout();
    notifyListeners();
  }

  String homeRouteForRole(UserRole role) => switch (role) {
        UserRole.staff => '/staff',
        UserRole.admin => '/admin',
        UserRole.superadmin => '/superadmin',
      };
}
