class Payment {
  final String paymentID;
  final double paymentAmount;
  final String? paymentDate;
  final String? paymentMethod;
  final String paymentStatus;
  final String allocation;

  const Payment({
    required this.paymentID,
    required this.paymentAmount,
    this.paymentDate,
    this.paymentMethod,
    required this.paymentStatus,
    required this.allocation,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      paymentID: json['payment_ID'] as String,
      paymentAmount: (json['payment_amount'] as num).toDouble(),
      paymentDate: json['payment_date'] as String?,
      paymentMethod: json['payment_method'] as String?,
      paymentStatus: json['payment_status'] as String,
      allocation: json['allocation'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment_amount': paymentAmount,
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
      'allocation': allocation,
    };
  }
}