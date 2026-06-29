import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/data/models/transport.dart';

/// Payload for fulfilling an approved request (Transport → Allocation → inventory links).
class FulfillmentSubmission {
  const FulfillmentSubmission({
    required this.requestId,
    required this.inventoryUnitIds,
    required this.fulfillingBranchId,
    this.transport,
  });

  final int requestId;
  final List<int> inventoryUnitIds;
  final int fulfillingBranchId;
  final Transport? transport;
}

class FulfillmentResult {
  const FulfillmentResult({
    required this.allocation,
    this.transport,
  });

  final Allocation allocation;
  final Transport? transport;
}

abstract class FulfillmentRepository {
  Future<FulfillmentResult> fulfillRequest(FulfillmentSubmission submission);
  Future<int> countAvailableUnits({
    required int branchId,
    required BloodGroup bloodGroup,
  });
  Future<int> countBranchesWithStock({required BloodGroup bloodGroup});
}
