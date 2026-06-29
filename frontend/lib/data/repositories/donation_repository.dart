import 'package:frontend/data/models/donation.dart';

abstract class DonationRepository {
  Future<List<Donation>> getDonationsForDonor(String nationalId);
  Future<Donation?> getDonation(int id);
  Future<Donation> createDonation(Donation donation);
  Future<int> countDonationsToday({int? branchId});
}
