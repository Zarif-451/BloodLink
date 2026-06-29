import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/data/mock/mock_data.dart';
import 'package:frontend/data/models/inventory_unit.dart';
import 'package:frontend/data/repositories/inventory_repository.dart';

class MockInventoryRepository implements InventoryRepository {
  int _nextId = 100;

  MockInventoryRepository() {
    if (MockData.inventory.isNotEmpty) {
      _nextId = MockData.inventory.map((u) => u.id).reduce((a, b) => a > b ? a : b) + 1;
    }
  }

  @override
  Future<InventoryUnit> addUnit(InventoryUnit unit) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final created = InventoryUnit(
      id: _nextId++,
      branchId: unit.branchId,
      bloodGroup: unit.bloodGroup,
      unitNumber: unit.unitNumber,
      collectionDate: unit.collectionDate,
      expiryDate: unit.expiryDate,
      quantity: unit.quantity,
      status: unit.status,
      sourceDonationId: unit.sourceDonationId,
    );
    MockData.inventory.add(created);
    return created;
  }

  @override
  Future<int> countAvailable({int? branchId}) async {
    return MockData.inventory
        .where((u) =>
            u.status == InventoryStatus.available &&
            (branchId == null || u.branchId == branchId))
        .length;
  }

  @override
  Future<int> countExpiringSoon({int? branchId, int withinDays = 7}) async {
    final deadline = DateTime.now().add(Duration(days: withinDays));
    return MockData.inventory.where((u) {
      if (branchId != null && u.branchId != branchId) return false;
      return u.status == InventoryStatus.available &&
          !u.expiryDate.isBefore(DateTime.now()) &&
          u.expiryDate.isBefore(deadline);
    }).length;
  }

  @override
  Future<Map<BloodGroup, int>> countByBloodGroup({
    int? branchId,
    InventoryStatus? status,
  }) async {
    final counts = <BloodGroup, int>{};
    for (final unit in MockData.inventory) {
      if (branchId != null && unit.branchId != branchId) continue;
      if (status != null && unit.status != status) continue;
      counts[unit.bloodGroup] = (counts[unit.bloodGroup] ?? 0) + unit.quantity;
    }
    return counts;
  }

  @override
  Future<InventoryUnit?> getUnit(int id) async {
    try {
      return MockData.inventory.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<InventoryUnit?> getUnitByDonation(int donationId) async {
    try {
      return MockData.inventory
          .firstWhere((u) => u.sourceDonationId == donationId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<InventoryUnit>> getUnits({
    int? branchId,
    BloodGroup? bloodGroup,
    InventoryStatus? status,
    bool nearExpiryOnly = false,
    int expiryWithinDays = 7,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final deadline = DateTime.now().add(Duration(days: expiryWithinDays));
    final list = MockData.inventory.where((u) {
      if (branchId != null && u.branchId != branchId) return false;
      if (bloodGroup != null && u.bloodGroup != bloodGroup) return false;
      if (status != null && u.status != status) return false;
      if (nearExpiryOnly) {
        if (u.status != InventoryStatus.available) return false;
        if (u.expiryDate.isBefore(DateTime.now())) return false;
        if (!u.expiryDate.isBefore(deadline)) return false;
      }
      return true;
    }).toList();
    list.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
    return list;
  }

  @override
  String suggestUnitNumber({
    required int branchId,
    required BloodGroup bloodGroup,
  }) {
    final prefix = branchId == MockData.dhakaBranchId ? 'DH' : 'CT';
    final groupCode = bloodGroup.label.replaceAll('−', '-');
    final count = MockData.inventory
            .where((u) => u.branchId == branchId && u.bloodGroup == bloodGroup)
            .length +
        1;
    return '$prefix-$groupCode-${count.toString().padLeft(3, '0')}';
  }

  @override
  Future<InventoryUnit> updateUnit(InventoryUnit unit) async {
    final index = MockData.inventory.indexWhere((u) => u.id == unit.id);
    if (index >= 0) MockData.inventory[index] = unit;
    return unit;
  }
}
