import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/data/models/user.dart';

abstract class UserRepository {
  Future<List<AppUser>> getUsers({int? branchId, UserRole? role});
  Future<AppUser?> getUser(int id);
  Future<AppUser> createUser(AppUser user);
  Future<AppUser> updateUser(AppUser user);
}
