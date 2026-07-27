class Branch {
  final String branchID;
  final String branchName;
  final String district;
  final String street;
  final String area;
  final String city;
  final String branchStatus;
  final String user;

  const Branch({
    required this.branchID,
    required this.branchName,
    required this.district,
    required this.street,
    required this.area,
    required this.city,
    required this.branchStatus,
    required this.user,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      branchID: json['branch_ID'] as String,
      branchName: json['branch_name'] as String,
      district: json['district'] as String,
      street: json['street'] as String,
      area: json['area'] as String,
      city: json['city'] as String,
      branchStatus: json['branch_status'] as String,
      user: json['user'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branch_name': branchName,
      'district': district,
      'street': street,
      'area': area,
      'city': city,
      'branch_status': branchStatus,
      'user': user,
    };
  }
}