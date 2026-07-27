class Allocation {
  final String allocationID;
  final String requestID;
  final int allocatedQuantity;
  final String allocationDate;
  final String allocationStatus;

  const Allocation({
    required this.allocationID,
    required this.requestID,
    required this.allocatedQuantity,
    required this.allocationDate,
    required this.allocationStatus,
  });

  factory Allocation.fromJson(Map<String, dynamic> json) {
    return Allocation(
      allocationID: json['allocation_ID'] as String,
      requestID: json['request_ID'] as String? ?? '',
      allocatedQuantity: json['allocated_quantity'] as int,
      allocationDate: json['allocation_date'] as String,
      allocationStatus: json['allocation_status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'request_ID': requestID,
    };
  }
}