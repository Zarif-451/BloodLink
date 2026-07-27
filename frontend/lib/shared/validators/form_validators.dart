class FormValidators {
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(value.trim())) return 'Invalid email address';
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final regex = RegExp(r'^\d{10,15}$');
    if (!regex.hasMatch(value.trim())) return 'Invalid phone number';
    return null;
  }

  static String? positiveInt(String? value) {
    if (value == null || value.trim().isEmpty) return 'This field is required';
    final v = int.tryParse(value.trim());
    if (v == null || v <= 0) return 'Must be greater than 0';
    return null;
  }

  static String? bpFormat(String? value) {
    if (value == null || value.trim().isEmpty) return 'Blood pressure is required';
    final regex = RegExp(r'^\d{2,3}/\d{2,3}$');
    if (!regex.hasMatch(value.trim())) return 'Format: 120/80';
    return null;
  }
}