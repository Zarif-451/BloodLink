class BloodInventory {
  final String inventoryID;
  final String bloodGroup;
  final String collectionDate;
  final String status;
  final String branch;
  final String? request;
  final String? allocation;

  const BloodInventory({
    required this.inventoryID,
    required this.bloodGroup,
    required this.collectionDate,
    required this.status,
    required this.branch,
    this.request,
    this.allocation,
  });

  factory BloodInventory.fromJson(Map<String, dynamic> json) {
    return BloodInventory(
      inventoryID: json['inventory_ID'] as String,
      bloodGroup: json['blood_group'] as String,
      collectionDate: json['collection_date'] as String,
      status: json['status'] as String,
      branch: json['branch'] as String,
      request: json['request'] as String?,
      allocation: json['allocation'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'blood_group': bloodGroup,
      'collection_date': collectionDate,
      'status': status,
      'branch': branch,
    };
  }
}