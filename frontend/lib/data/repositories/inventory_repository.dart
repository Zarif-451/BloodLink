import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/data/models/inventory_unit.dart';

abstract class InventoryRepository {
  Future<List<InventoryUnit>> getUnits({
    int? branchId,
    BloodGroup? bloodGroup,
    InventoryStatus? status,
    bool nearExpiryOnly = false,
    int expiryWithinDays = 7,
  });
  Future<InventoryUnit?> getUnit(int id);
  Future<InventoryUnit?> getUnitByDonation(int donationId);
  Future<InventoryUnit> addUnit(InventoryUnit unit);
  Future<InventoryUnit> updateUnit(InventoryUnit unit);
  Future<int> countAvailable({int? branchId});
  Future<int> countExpiringSoon({int? branchId, int withinDays = 7});
  Future<Map<BloodGroup, int>> countByBloodGroup({
    int? branchId,
    InventoryStatus? status,
  });
  String suggestUnitNumber({required int branchId, required BloodGroup bloodGroup});
}
