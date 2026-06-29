import 'package:frontend/core/constants/enums.dart';

class Transport {
  const Transport({
    required this.id,
    required this.sourceBranchId,
    required this.destinationType,
    required this.destinationName,
    required this.status,
    this.dispatchedTime,
    this.receivedTime,
    this.scheduledDate,
  });

  final int id;
  final int sourceBranchId;
  final DestinationType destinationType;
  final String destinationName;
  final TransportStatus status;
  final DateTime? dispatchedTime;
  final DateTime? receivedTime;
  final DateTime? scheduledDate;

  Transport copyWith({
    TransportStatus? status,
    DateTime? dispatchedTime,
    DateTime? receivedTime,
  }) {
    return Transport(
      id: id,
      sourceBranchId: sourceBranchId,
      destinationType: destinationType,
      destinationName: destinationName,
      status: status ?? this.status,
      dispatchedTime: dispatchedTime ?? this.dispatchedTime,
      receivedTime: receivedTime ?? this.receivedTime,
      scheduledDate: scheduledDate,
    );
  }
}

class Allocation {
  const Allocation({
    required this.id,
    required this.requestId,
    required this.transportId,
    required this.allocatedQuantity,
    required this.allocationDate,
    required this.status,
    this.inventoryIds = const [],
  });

  final int id;
  final int requestId;
  final int transportId;
  final int allocatedQuantity;
  final DateTime allocationDate;
  final AllocationStatus status;
  final List<int> inventoryIds;
}
