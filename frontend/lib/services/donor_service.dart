import '../core/api_client.dart';
import '../models/donor.dart';

class DonorService {
  final ApiClient _client;

  DonorService(this._client);

  Future<List<Donor>> getAll() async {
    throw UnimplementedError();
  }

  Future<Donor> getById(String id) async {
    throw UnimplementedError();
  }

  Future<Donor> create(Map<String, dynamic> data) async {
    throw UnimplementedError();
  }

  Future<Donor> update(String id, Map<String, dynamic> data) async {
    throw UnimplementedError();
  }

  Future<Donor> partialUpdate(String id, Map<String, dynamic> data) async {
    throw UnimplementedError();
  }

  Future<void> delete(String id) async {
    throw UnimplementedError();
  }

  Future<List<Map<String, dynamic>>> getPhones(String nationalId) async {
    throw UnimplementedError();
  }

  Future<Map<String, dynamic>> addPhone(
      String nationalId, String phone) async {
    throw UnimplementedError();
  }

  Future<void> deletePhone(String nationalId, String phone) async {
    throw UnimplementedError();
  }
}