import 'package:frontend/data/models/payment.dart';

abstract class PaymentRepository {
  Future<List<Payment>> getPayments({int? branchId});
  Future<Payment?> getPayment(int id);
  Future<Payment?> getPaymentForRequest(int requestId);
  Future<Payment> confirmPayment(int id);
}
