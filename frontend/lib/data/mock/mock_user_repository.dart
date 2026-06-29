import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/data/mock/mock_data.dart';
import 'package:frontend/data/models/user.dart';
import 'package:frontend/data/repositories/user_repository.dart';

class MockUserRepository implements UserRepository {
  int _nextId = 100;

  MockUserRepository() {
    if (MockData.users.isNotEmpty) {
      _nextId =
          MockData.users.map((u) => u.id).reduce((a, b) => a > b ? a : b) + 1;
    }
  }

  @override
  Future<AppUser> createUser(AppUser user) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final created = user.copyWith(id: _nextId++);
    MockData.users.add(created);
    return created;
  }

  @override
  Future<AppUser?> getUser(int id) async {
    try {
      return MockData.users.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<AppUser>> getUsers({int? branchId, UserRole? role}) async {
    return MockData.users.where((u) {
      if (branchId != null && u.branchId != branchId) return false;
      if (role != null && u.role != role) return false;
      return true;
    }).toList();
  }

  @override
  Future<AppUser> updateUser(AppUser user) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final i = MockData.users.indexWhere((u) => u.id == user.id);
    if (i < 0) throw StateError('User not found');
    MockData.users[i] = user;
    return user;
  }
}
