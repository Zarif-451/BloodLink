import '../core/api_client.dart';
import '../models/payment.dart';

class PaymentService {
  final ApiClient _client;

  PaymentService(this._client);

  Future<List<Payment>> getAll() async {
    throw UnimplementedError();
  }

  Future<Payment> getById(String id) async {
    throw UnimplementedError();
  }

  Future<Payment> update(String id, Map<String, dynamic> data) async {
    throw UnimplementedError();
  }

  Future<Payment> partialUpdate(String id, Map<String, dynamic> data) async {
    throw UnimplementedError();
  }
}