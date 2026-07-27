import '../core/api_client.dart';

class AllocationService {
  final ApiClient _client;

  AllocationService(this._client);

  Future<List<dynamic>> getAll() async {
    throw UnimplementedError();
  }

  Future<dynamic> getById(String id) async {
    throw UnimplementedError();
  }

  Future<dynamic> create(String requestId) async {
    throw UnimplementedError();
  }

  Future<void> delete(String id) async {
    throw UnimplementedError();
  }
}