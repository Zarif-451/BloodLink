import 'package:frontend/core/constants/enums.dart';

class Requester {
  const Requester({
    required this.id,
    required this.type,
    required this.name,
    this.street = '',
    this.area = '',
    this.city = '',
    this.phones = const [],
  });

  final int id;
  final RequesterType type;
  final String name;
  final String street;
  final String area;
  final String city;
  final List<String> phones;
}

class BloodRequest {
  const BloodRequest({
    required this.id,
    required this.requesterId,
    required this.bloodGroup,
    required this.quantity,
    required this.urgency,
    required this.requestDate,
    required this.status,
    this.requesterName,
    this.rejectReason,
  });

  final int id;
  final int requesterId;
  final BloodGroup bloodGroup;
  final int quantity;
  final Urgency urgency;
  final DateTime requestDate;
  final RequestStatus status;
  final String? requesterName;
  final String? rejectReason;

  BloodRequest copyWith({
    RequestStatus? status,
    String? rejectReason,
    bool clearRejectReason = false,
  }) {
    return BloodRequest(
      id: id,
      requesterId: requesterId,
      bloodGroup: bloodGroup,
      quantity: quantity,
      urgency: urgency,
      requestDate: requestDate,
      status: status ?? this.status,
      requesterName: requesterName,
      rejectReason:
          clearRejectReason ? null : (rejectReason ?? this.rejectReason),
    );
  }
}
