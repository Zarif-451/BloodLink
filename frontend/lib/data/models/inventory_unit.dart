import 'package:frontend/core/constants/enums.dart';

class InventoryUnit {
  const InventoryUnit({
    required this.id,
    required this.branchId,
    required this.bloodGroup,
    required this.unitNumber,
    required this.collectionDate,
    required this.expiryDate,
    required this.quantity,
    required this.status,
    this.sourceDonationId,
  });

  final int id;
  final int branchId;
  final BloodGroup bloodGroup;
  final String unitNumber;
  final DateTime collectionDate;
  final DateTime expiryDate;
  final int quantity;
  final InventoryStatus status;
  final int? sourceDonationId;

  InventoryUnit copyWith({
    int? id,
    int? branchId,
    BloodGroup? bloodGroup,
    String? unitNumber,
    DateTime? collectionDate,
    DateTime? expiryDate,
    int? quantity,
    InventoryStatus? status,
    int? sourceDonationId,
  }) {
    return InventoryUnit(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      unitNumber: unitNumber ?? this.unitNumber,
      collectionDate: collectionDate ?? this.collectionDate,
      expiryDate: expiryDate ?? this.expiryDate,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
      sourceDonationId: sourceDonationId ?? this.sourceDonationId,
    );
  }
}
