import 'package:frontend/core/constants/enums.dart';
import 'package:frontend/data/mock/mock_data.dart';
import 'package:frontend/data/models/payment.dart';
import 'package:frontend/data/repositories/payment_repository.dart';

class MockPaymentRepository implements PaymentRepository {
  @override
  Future<Payment> confirmPayment(int id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final index = MockData.payments.indexWhere((p) => p.id == id);
    if (index < 0) throw StateError('Payment not found');
    final updated = MockData.payments[index].copyWith(status: PaymentStatus.paid);
    MockData.payments[index] = updated;
    return updated;
  }

  @override
  Future<Payment?> getPayment(int id) async {
    try {
      return MockData.payments.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Payment?> getPaymentForRequest(int requestId) async {
    try {
      return MockData.payments.firstWhere(
        (p) => p.requestId == requestId && p.status == PaymentStatus.pending,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Payment>> getPayments({int? branchId}) async {
    return List.of(MockData.payments);
  }
}
