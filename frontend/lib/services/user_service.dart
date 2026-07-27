import '../core/api_client.dart';
import '../models/user.dart';

class UserService {
  final ApiClient _client;

  UserService(this._client);

  Future<List<User>> getAll() async {
    throw UnimplementedError();
  }

  Future<User> getById(String id) async {
    throw UnimplementedError();
  }

  Future<User> create(Map<String, dynamic> data) async {
    throw UnimplementedError();
  }

  Future<User> update(String id, Map<String, dynamic> data) async {
    throw UnimplementedError();
  }

  Future<User> partialUpdate(String id, Map<String, dynamic> data) async {
    throw UnimplementedError();
  }

  Future<void> delete(String id) async {
    throw UnimplementedError();
  }
}