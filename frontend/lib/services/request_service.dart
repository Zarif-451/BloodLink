import '../core/api_client.dart';
import '../models/blood_request.dart';

class RequestService {
  final ApiClient _client;

  RequestService(this._client);

  Future<List<BloodRequest>> getAll() async {
    throw UnimplementedError();
  }

  Future<BloodRequest> getById(String id) async {
    throw UnimplementedError();
  }

  Future<BloodRequest> create(Map<String, dynamic> data) async {
    throw UnimplementedError();
  }

  Future<BloodRequest> update(String id, Map<String, dynamic> data) async {
    throw UnimplementedError();
  }

  Future<BloodRequest> partialUpdate(
      String id, Map<String, dynamic> data) async {
    throw UnimplementedError();
  }

  Future<void> delete(String id) async {
    throw UnimplementedError();
  }
}