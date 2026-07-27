import '../core/api_client.dart';
import '../models/blood_inventory.dart';

class InventoryService {
  final ApiClient _client;

  InventoryService(this._client);

  Future<List<BloodInventory>> getAll() async {
    throw UnimplementedError();
  }

  Future<BloodInventory> getById(String id) async {
    throw UnimplementedError();
  }

  Future<BloodInventory> create(Map<String, dynamic> data) async {
    throw UnimplementedError();
  }

  Future<BloodInventory> update(String id, Map<String, dynamic> data) async {
    throw UnimplementedError();
  }

  Future<BloodInventory> partialUpdate(
      String id, Map<String, dynamic> data) async {
    throw UnimplementedError();
  }

  Future<void> delete(String id) async {
    throw UnimplementedError();
  }
}