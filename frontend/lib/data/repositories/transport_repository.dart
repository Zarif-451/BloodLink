import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/data/models/transport.dart';

abstract class TransportRepository {
  Future<List<Transport>> getTransports({
    int? branchId,
    TransportStatus? status,
  });
  Future<Transport?> getTransport(int id);
  Future<Transport> createTransport(Transport transport);
  Future<Transport> updateTransport(Transport transport);
}

abstract class AllocationRepository {
  Future<Allocation> createAllocation(Allocation allocation);
  Future<List<Allocation>> getAllocationsForRequest(int requestId);
  Future<List<Allocation>> getUnlinkedAllocations({int? branchId});
  Future<Allocation> linkTransport(int allocationId, int transportId);
}
