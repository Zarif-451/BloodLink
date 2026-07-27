import '../core/api_client.dart';
import '../models/donation.dart';

class DonationService {
  final ApiClient _client;

  DonationService(this._client);

  Future<List<Donation>> getAll() async {
    throw UnimplementedError();
  }

  Future<Donation> getById(String id) async {
    throw UnimplementedError();
  }

  Future<Donation> create(Map<String, dynamic> data) async {
    throw UnimplementedError();
  }

  Future<Donation> update(String id, Map<String, dynamic> data) async {
    throw UnimplementedError();
  }

  Future<Donation> partialUpdate(String id, Map<String, dynamic> data) async {
    throw UnimplementedError();
  }

  Future<void> delete(String id) async {
    throw UnimplementedError();
  }
}