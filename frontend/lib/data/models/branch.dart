import 'package:frontend/core/constants/enums.dart';

class Branch {
  const Branch({
    required this.id,
    required this.name,
    required this.district,
    this.street = '',
    this.area = '',
    this.city = '',
    this.postalCode = '',
    this.phones = const [],
    this.status = BranchStatus.active,
    this.adminUserId,
  });

  final int id;
  final String name;
  final String district;
  final String street;
  final String area;
  final String city;
  final String postalCode;
  final List<String> phones;
  final BranchStatus status;
  final int? adminUserId;

  Branch copyWith({
    int? id,
    String? name,
    String? district,
    String? street,
    String? area,
    String? city,
    String? postalCode,
    List<String>? phones,
    BranchStatus? status,
    int? adminUserId,
  }) {
    return Branch(
      id: id ?? this.id,
      name: name ?? this.name,
      district: district ?? this.district,
      street: street ?? this.street,
      area: area ?? this.area,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      phones: phones ?? this.phones,
      status: status ?? this.status,
      adminUserId: adminUserId ?? this.adminUserId,
    );
  }
}
