import '../core/api_client.dart';
import '../models/transport.dart';

class TransportService {
  final ApiClient _client;

  TransportService(this._client);

  Future<List<Transport>> getAll() async {
    throw UnimplementedError();
  }

  Future<Transport> getById(String id) async {
    throw UnimplementedError();
  }

  Future<Transport> create(Map<String, dynamic> data) async {
    throw UnimplementedError();
  }

  Future<Transport> update(String id, Map<String, dynamic> data) async {
    throw UnimplementedError();
  }

  Future<Transport> partialUpdate(String id, Map<String, dynamic> data) async {
    throw UnimplementedError();
  }

  Future<void> delete(String id) async {
    throw UnimplementedError();
  }
}