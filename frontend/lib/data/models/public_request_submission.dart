import 'package:frontend/core/constants/enums.dart';

/// Payload for the public request-blood wizard (no auth).
class PublicRequestSubmission {
  const PublicRequestSubmission({
    required this.requesterType,
    required this.name,
    required this.phones,
    required this.bloodGroup,
    required this.quantity,
    required this.urgency,
    this.street = '',
    this.area = '',
    this.city = '',
    this.postalCode = '',
  });

  final RequesterType requesterType;
  final String name;
  final List<String> phones;
  final String street;
  final String area;
  final String city;
  final String postalCode;
  final BloodGroup bloodGroup;
  final int quantity;
  final Urgency urgency;
}

/// Format / parse public-facing request IDs (e.g. BL-1042).
abstract final class PublicRequestId {
  static String format(int id) => 'BL-$id';

  static int? parse(String input) {
    final trimmed = input.trim().toUpperCase();
    final numeric = trimmed.startsWith('BL-')
        ? trimmed.substring(3)
        : trimmed.startsWith('BL')
            ? trimmed.substring(2)
            : trimmed;
    return int.tryParse(numeric);
  }
}
