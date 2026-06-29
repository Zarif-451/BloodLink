import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/data/mock/mock_data.dart';
import 'package:frontend/data/models/transport.dart';
import 'package:frontend/data/repositories/transport_repository.dart';

class MockTransportRepository implements TransportRepository {
  int _nextId = 100;

  MockTransportRepository() {
    if (MockData.transports.isNotEmpty) {
      _nextId =
          MockData.transports.map((t) => t.id).reduce((a, b) => a > b ? a : b) +
              1;
    }
  }

  @override
  Future<Transport> createTransport(Transport transport) async {
    final created = Transport(
      id: _nextId++,
      sourceBranchId: transport.sourceBranchId,
      destinationType: transport.destinationType,
      destinationName: transport.destinationName,
      status: transport.status,
      dispatchedTime: transport.dispatchedTime,
      receivedTime: transport.receivedTime,
      scheduledDate: transport.scheduledDate,
    );
    MockData.transports.insert(0, created);
    return created;
  }

  @override
  Future<Transport?> getTransport(int id) async {
    try {
      return MockData.transports.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Transport>> getTransports({
    int? branchId,
    TransportStatus? status,
  }) async {
    return MockData.transports.where((t) {
      if (branchId != null && t.sourceBranchId != branchId) return false;
      if (status != null && t.status != status) return false;
      return true;
    }).toList()
      ..sort((a, b) {
        final ad = a.scheduledDate ?? a.dispatchedTime ?? DateTime(2000);
        final bd = b.scheduledDate ?? b.dispatchedTime ?? DateTime(2000);
        return bd.compareTo(ad);
      });
  }

  @override
  Future<Transport> updateTransport(Transport transport) async {
    final i = MockData.transports.indexWhere((t) => t.id == transport.id);
    if (i >= 0) MockData.transports[i] = transport;

    final allocations = MockData.allocations
        .where((a) => a.transportId == transport.id)
        .toList();
    for (final allocation in allocations) {
      final reqIndex =
          MockData.requests.indexWhere((r) => r.id == allocation.requestId);
      if (reqIndex < 0) continue;
      final req = MockData.requests[reqIndex];
      if (transport.status == TransportStatus.inTransit ||
          transport.status == TransportStatus.dispatched) {
        MockData.requests[reqIndex] =
            req.copyWith(status: RequestStatus.inTransit);
      } else if (transport.status == TransportStatus.delivered) {
        MockData.requests[reqIndex] =
            req.copyWith(status: RequestStatus.fulfilled);
      }
    }
    return transport;
  }
}

class MockAllocationRepository implements AllocationRepository {
  int _nextId = 100;

  MockAllocationRepository() {
    if (MockData.allocations.isNotEmpty) {
      _nextId =
          MockData.allocations.map((a) => a.id).reduce((a, b) => a > b ? a : b) +
              1;
    }
  }

  @override
  Future<Allocation> createAllocation(Allocation allocation) async {
    final created = Allocation(
      id: _nextId++,
      requestId: allocation.requestId,
      transportId: allocation.transportId,
      allocatedQuantity: allocation.allocatedQuantity,
      allocationDate: allocation.allocationDate,
      status: allocation.status,
      inventoryIds: allocation.inventoryIds,
    );
    MockData.allocations.add(created);
    return created;
  }

  @override
  Future<List<Allocation>> getAllocationsForRequest(int requestId) async {
    return MockData.allocations.where((a) => a.requestId == requestId).toList();
  }

  @override
  Future<List<Allocation>> getUnlinkedAllocations({int? branchId}) async {
    return MockData.allocations
        .where((a) => a.transportId == 0)
        .toList();
  }

  @override
  Future<Allocation> linkTransport(int allocationId, int transportId) async {
    final i = MockData.allocations.indexWhere((a) => a.id == allocationId);
    if (i < 0) throw StateError('Allocation not found');
    final old = MockData.allocations[i];
    final updated = Allocation(
      id: old.id,
      requestId: old.requestId,
      transportId: transportId,
      allocatedQuantity: old.allocatedQuantity,
      allocationDate: old.allocationDate,
      status: old.status,
      inventoryIds: old.inventoryIds,
    );
    MockData.allocations[i] = updated;
    return updated;
  }
}
