class Donor {
  final String nationalID;
  final String fullName;
  final String dateOfBirth;
  final String gender;
  final String bloodGroup;
  final String street;
  final String area;
  final String city;
  final String user;

  const Donor({
    required this.nationalID,
    required this.fullName,
    required this.dateOfBirth,
    required this.gender,
    required this.bloodGroup,
    required this.street,
    required this.area,
    required this.city,
    required this.user,
  });

  factory Donor.fromJson(Map<String, dynamic> json) {
    return Donor(
      nationalID: json['national_ID'] as String,
      fullName: json['full_name'] as String,
      dateOfBirth: json['date_of_birth'] as String,
      gender: json['gender'] as String,
      bloodGroup: json['blood_group'] as String,
      street: json['street'] as String,
      area: json['area'] as String,
      city: json['city'] as String,
      user: json['user'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'national_ID': nationalID,
      'full_name': fullName,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'blood_group': bloodGroup,
      'street': street,
      'area': area,
      'city': city,
      'user': user,
    };
  }
}