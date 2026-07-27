import '../core/api_client.dart';
import '../models/branch.dart';

class BranchService {
  final ApiClient _client;

  BranchService(this._client);

  Future<List<Branch>> getAll() async {
    throw UnimplementedError();
  }

  Future<Branch> getById(String id) async {
    throw UnimplementedError();
  }

  Future<Branch> create(Map<String, dynamic> data) async {
    throw UnimplementedError();
  }

  Future<Branch> update(String id, Map<String, dynamic> data) async {
    throw UnimplementedError();
  }

  Future<Branch> partialUpdate(String id, Map<String, dynamic> data) async {
    throw UnimplementedError();
  }

  Future<void> delete(String id) async {
    throw UnimplementedError();
  }

  Future<List<Map<String, dynamic>>> getPhones(String branchId) async {
    throw UnimplementedError();
  }

  Future<Map<String, dynamic>> addPhone(String branchId, String phone) async {
    throw UnimplementedError();
  }

  Future<void> deletePhone(String branchId, String phone) async {
    throw UnimplementedError();
  }
}