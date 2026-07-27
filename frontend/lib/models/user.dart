class User {
  final String userID;
  final String fullName;
  final String email;
  final String role;
  final String status;

  const User({
    required this.userID,
    required this.fullName,
    required this.email,
    required this.role,
    this.status = 'Active',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userID: json['user_ID'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      status: json['status'] as String? ?? 'Active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'email': email,
      'password': '',
      'role': role,
      'status': status,
    };
  }
}