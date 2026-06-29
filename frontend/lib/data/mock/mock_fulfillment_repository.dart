import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/data/mock/mock_data.dart';
import 'package:frontend/data/models/transport.dart';
import 'package:frontend/data/repositories/fulfillment_repository.dart';
import 'package:frontend/data/repositories/inventory_repository.dart';
import 'package:frontend/data/repositories/transport_repository.dart';

class MockFulfillmentRepository implements FulfillmentRepository {
  MockFulfillmentRepository(
    this._inventory,
    this._transport,
    this._allocation,
  );

  final InventoryRepository _inventory;
  final TransportRepository _transport;
  final AllocationRepository _allocation;

  int _nextAllocationId = 100;

  @override
  Future<int> countAvailableUnits({
    required int branchId,
    required BloodGroup bloodGroup,
  }) async {
    final units = await _inventory.getUnits(
      branchId: branchId,
      bloodGroup: bloodGroup,
      status: InventoryStatus.available,
    );
    return units.fold<int>(0, (sum, u) => sum + u.quantity);
  }

  @override
  Future<int> countBranchesWithStock({required BloodGroup bloodGroup}) async {
    var count = 0;
    for (final branch in MockData.branches) {
      final n = await countAvailableUnits(
        branchId: branch.id,
        bloodGroup: bloodGroup,
      );
      if (n > 0) count++;
    }
    return count;
  }

  @override
  Future<FulfillmentResult> fulfillRequest(
    FulfillmentSubmission submission,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final requestIndex =
        MockData.requests.indexWhere((r) => r.id == submission.requestId);
    if (requestIndex < 0) throw StateError('Request not found');
    final request = MockData.requests[requestIndex];
    if (request.status != RequestStatus.approved) {
      throw StateError('Request must be approved before allocation');
    }

    Transport? createdTransport;
    if (submission.transport != null) {
      createdTransport =
          await _transport.createTransport(submission.transport!);
    }

    for (final unitId in submission.inventoryUnitIds) {
      final unit = await _inventory.getUnit(unitId);
      if (unit == null) throw StateError('Unit $unitId not found');
      if (unit.status != InventoryStatus.available) {
        throw StateError('Unit ${unit.unitNumber} is not available');
      }
      if (unit.bloodGroup != request.bloodGroup) {
        throw StateError('Blood group mismatch');
      }
      await _inventory.updateUnit(
        unit.copyWith(status: InventoryStatus.reserved),
      );
    }

    if (MockData.allocations.isNotEmpty) {
      _nextAllocationId =
          MockData.allocations.map((a) => a.id).reduce((a, b) => a > b ? a : b) +
              1;
    }

    final allocation = Allocation(
      id: _nextAllocationId++,
      requestId: submission.requestId,
      transportId: createdTransport?.id ?? 0,
      allocatedQuantity: submission.inventoryUnitIds.length,
      allocationDate: DateTime.now(),
      status: AllocationStatus.confirmed,
      inventoryIds: submission.inventoryUnitIds,
    );
    await _allocation.createAllocation(allocation);

    MockData.requests[requestIndex] = request.copyWith(
      status: RequestStatus.allocated,
    );

    return FulfillmentResult(
      allocation: allocation,
      transport: createdTransport,
    );
  }
}
