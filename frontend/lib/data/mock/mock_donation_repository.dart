import 'package:frontend/data/mock/mock_data.dart';
import 'package:frontend/data/models/donation.dart';
import 'package:frontend/data/repositories/donation_repository.dart';

class MockDonationRepository implements DonationRepository {
  int _nextId = 100;

  MockDonationRepository() {
    if (MockData.donations.isNotEmpty) {
      _nextId = MockData.donations.map((d) => d.id).reduce((a, b) => a > b ? a : b) + 1;
    }
  }

  static const _eligibleGapDays = 56;

  @override
  Future<Donation> createDonation(Donation donation) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final eligibleNext = donation.eligibleNextDate ??
        donation.donationDate.add(const Duration(days: _eligibleGapDays));
    final created = Donation(
      id: _nextId++,
      nationalId: donation.nationalId,
      unitsDonated: donation.unitsDonated,
      donationDate: donation.donationDate,
      eligibleNextDate: eligibleNext,
      notes: donation.notes,
    );
    MockData.donations.add(created);
    _updateDonorAfterDonation(created);
    return created;
  }

  void _updateDonorAfterDonation(Donation donation) {
    final index =
        MockData.donors.indexWhere((d) => d.nationalId == donation.nationalId);
    if (index < 0) return;
    final existing = MockData.donors[index];
    MockData.donors[index] = existing.copyWith(
      lastDonationDate: donation.donationDate,
      eligibleNextDate: donation.eligibleNextDate,
    );
  }

  @override
  Future<Donation?> getDonation(int id) async {
    try {
      return MockData.donations.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Donation>> getDonationsForDonor(String nationalId) async {
    final list =
        MockData.donations.where((d) => d.nationalId == nationalId).toList();
    list.sort((a, b) => b.donationDate.compareTo(a.donationDate));
    return list;
  }

  @override
  Future<int> countDonationsToday({int? branchId}) async {
    final today = DateTime.now();
    bool isToday(DateTime d) =>
        d.year == today.year && d.month == today.month && d.day == today.day;
    return MockData.donations.where((d) => isToday(d.donationDate)).length;
  }
}
