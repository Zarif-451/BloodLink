import 'package:frontend/core/constants/enums.dart';

class Payment {
  const Payment({
    required this.id,
    required this.allocationId,
    required this.amount,
    required this.paymentDate,
    required this.status,
    this.reason,
    this.requestId,
  });

  final int id;
  final int allocationId;
  final double amount;
  final DateTime paymentDate;
  final PaymentStatus status;
  final String? reason;
  final int? requestId;

  Payment copyWith({PaymentStatus? status}) {
    return Payment(
      id: id,
      allocationId: allocationId,
      amount: amount,
      paymentDate: paymentDate,
      status: status ?? this.status,
      reason: reason,
      requestId: requestId,
    );
  }
}
