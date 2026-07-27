import '../core/api_client.dart';

class ScreeningService {
  final ApiClient _client;

  ScreeningService(this._client);

  Future<List<dynamic>> getAll() async {
    throw UnimplementedError();
  }

  Future<dynamic> getById(String id) async {
    throw UnimplementedError();
  }

  Future<dynamic> create(Map<String, dynamic> data) async {
    throw UnimplementedError();
  }

  Future<dynamic> update(String id, Map<String, dynamic> data) async {
    throw UnimplementedError();
  }

  Future<void> delete(String id) async {
    throw UnimplementedError();
  }
}