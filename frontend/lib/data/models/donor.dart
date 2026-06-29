import 'package:frontend/core/constants/enums.dart';

class Donor {
  const Donor({
    required this.nationalId,
    required this.fullName,
    required this.bloodGroup,
    required this.dateOfBirth,
    required this.gender,
    this.street = '',
    this.area = '',
    this.city = '',
    this.postalCode = '',
    this.phones = const [],
    this.lastDonationDate,
    this.eligibleNextDate,
  });

  final String nationalId;
  final String fullName;
  final BloodGroup bloodGroup;
  final DateTime dateOfBirth;
  final Gender gender;
  final String street;
  final String area;
  final String city;
  final String postalCode;
  final List<String> phones;
  final DateTime? lastDonationDate;
  final DateTime? eligibleNextDate;

  bool get isEligible =>
      eligibleNextDate == null || !DateTime.now().isBefore(eligibleNextDate!);

  Donor copyWith({
    String? nationalId,
    String? fullName,
    BloodGroup? bloodGroup,
    DateTime? dateOfBirth,
    Gender? gender,
    String? street,
    String? area,
    String? city,
    String? postalCode,
    List<String>? phones,
    DateTime? lastDonationDate,
    DateTime? eligibleNextDate,
    bool clearLastDonationDate = false,
    bool clearEligibleNextDate = false,
  }) {
    return Donor(
      nationalId: nationalId ?? this.nationalId,
      fullName: fullName ?? this.fullName,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      street: street ?? this.street,
      area: area ?? this.area,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      phones: phones ?? this.phones,
      lastDonationDate:
          clearLastDonationDate ? null : (lastDonationDate ?? this.lastDonationDate),
      eligibleNextDate: clearEligibleNextDate
          ? null
          : (eligibleNextDate ?? this.eligibleNextDate),
    );
  }
}
