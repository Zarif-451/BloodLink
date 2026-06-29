import 'package:frontend/data/mock/mock_data.dart';
import 'package:frontend/data/models/donor.dart';
import 'package:frontend/data/repositories/donor_repository.dart';

class MockDonorRepository implements DonorRepository {
  @override
  Future<Donor> createDonor(Donor donor) async {
    MockData.donors.add(donor);
    return donor;
  }

  @override
  Future<Donor?> getDonor(String nationalId) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    try {
      return MockData.donors.firstWhere((d) => d.nationalId == nationalId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Donor>> getDonors({String? query}) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    if (query == null || query.trim().isEmpty) return List.of(MockData.donors);
    final q = query.toLowerCase();
    return MockData.donors.where((d) {
      return d.nationalId.contains(q) ||
          d.fullName.toLowerCase().contains(q) ||
          d.phones.any((p) => p.contains(q));
    }).toList();
  }

  @override
  Future<Donor> updateDonor(Donor donor) async {
    final i = MockData.donors.indexWhere((d) => d.nationalId == donor.nationalId);
    if (i >= 0) MockData.donors[i] = donor;
    return donor;
  }
}
