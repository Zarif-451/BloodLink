import 'package:frontend/core/constants/enums.dart';

class AppUser {
  const AppUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.branchId,
    this.phones = const [],
    this.status = UserStatus.active,
  });

  final int id;
  final String fullName;
  final String email;
  final UserRole role;
  final int branchId;
  final List<String> phones;
  final UserStatus status;

  AppUser copyWith({
    int? id,
    String? fullName,
    String? email,
    UserRole? role,
    int? branchId,
    List<String>? phones,
    UserStatus? status,
  }) {
    return AppUser(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      branchId: branchId ?? this.branchId,
      phones: phones ?? this.phones,
      status: status ?? this.status,
    );
  }
}
