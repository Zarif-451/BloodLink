import '../core/api_client.dart';
import '../models/requester.dart';

class RequesterService {
  final ApiClient _client;

  RequesterService(this._client);

  Future<List<Requester>> getAll() async {
    throw UnimplementedError();
  }

  Future<Requester> getById(String id) async {
    throw UnimplementedError();
  }

  Future<Requester> create(Map<String, dynamic> data) async {
    throw UnimplementedError();
  }

  Future<Requester> update(String id, Map<String, dynamic> data) async {
    throw UnimplementedError();
  }

  Future<void> delete(String id) async {
    throw UnimplementedError();
  }

  Future<List<Map<String, dynamic>>> getPhones(String requesterId) async {
    throw UnimplementedError();
  }

  Future<Map<String, dynamic>> addPhone(
      String requesterId, String phone) async {
    throw UnimplementedError();
  }

  Future<void> deletePhone(String requesterId, String phone) async {
    throw UnimplementedError();
  }
}