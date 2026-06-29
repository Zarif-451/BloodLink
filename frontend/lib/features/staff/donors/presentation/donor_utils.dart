import 'package:intl/intl.dart';

import 'package:frontend/data/models/donor.dart';

String maskNationalId(String nationalId) {
  if (nationalId.length <= 4) return nationalId;
  return '•••${nationalId.substring(nationalId.length - 4)}';
}

bool isDonorAdult(DateTime dateOfBirth) {
  final today = DateTime.now();
  var age = today.year - dateOfBirth.year;
  if (today.month < dateOfBirth.month ||
      (today.month == dateOfBirth.month && today.day < dateOfBirth.day)) {
    age--;
  }
  return age >= 18;
}

bool isValidNationalId(String value) {
  final digits = value.replaceAll(RegExp(r'\D'), '');
  return digits.length == 10 || digits.length == 13 || digits.length == 17;
}

String eligibilityLabel(Donor donor) {
  if (donor.isEligible) return 'Eligible';
  if (donor.eligibleNextDate != null) {
    return 'Eligible ${DateFormat.yMMMd().format(donor.eligibleNextDate!)}';
  }
  return 'Not eligible';
}
