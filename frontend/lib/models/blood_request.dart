class BloodRequest {
  final String requestID;
  final String bloodGroup;
  final int quantity;
  final String urgency;
  final String status;
  final String requestDate;
  final String requester;

  const BloodRequest({
    required this.requestID,
    required this.bloodGroup,
    required this.quantity,
    required this.urgency,
    required this.status,
    required this.requestDate,
    required this.requester,
  });

  factory BloodRequest.fromJson(Map<String, dynamic> json) {
    return BloodRequest(
      requestID: json['request_ID'] as String,
      bloodGroup: json['blood_group'] as String,
      quantity: json['quantity'] as int,
      urgency: json['urgency'] as String,
      status: json['status'] as String,
      requestDate: json['request_date'] as String,
      requester: json['requester'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'blood_group': bloodGroup,
      'quantity': quantity,
      'urgency': urgency,
      'status': status,
      'request_date': requestDate,
      'requester': requester,
    };
  }
}