import 'package:frontend/data/mock/mock_data.dart';
import 'package:frontend/data/models/donation.dart';
import 'package:frontend/data/models/screening.dart';
import 'package:frontend/data/repositories/screening_repository.dart';

class MockScreeningRepository implements ScreeningRepository {
  int _nextId = 100;

  MockScreeningRepository() {
    if (MockData.screenings.isNotEmpty) {
      _nextId = MockData.screenings.map((s) => s.id).reduce((a, b) => a > b ? a : b) + 1;
    }
  }

  @override
  Future<Screening> createScreening(Screening screening) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final created = Screening(
      id: _nextId++,
      donationId: screening.donationId,
      testedOn: screening.testedOn,
      testedByUserId: screening.testedByUserId,
      result: screening.result,
      hbLevel: screening.hbLevel,
      bp: screening.bp,
      hepatitisB: screening.hepatitisB,
      hepatitisC: screening.hepatitisC,
      hiv: screening.hiv,
      malaria: screening.malaria,
    );
    MockData.screenings.add(created);
    return created;
  }

  @override
  Future<Screening?> getScreeningForDonation(int donationId) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    try {
      return MockData.screenings.firstWhere((s) => s.donationId == donationId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Donation>> getDonationsPendingScreening() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final screenedIds = MockData.screenings.map((s) => s.donationId).toSet();
    return MockData.donations
        .where((d) => !screenedIds.contains(d.id))
        .toList()
      ..sort((a, b) => b.donationDate.compareTo(a.donationDate));
  }
}
