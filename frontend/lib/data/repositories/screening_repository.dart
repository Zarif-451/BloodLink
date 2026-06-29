import 'package:frontend/data/models/donation.dart';
import 'package:frontend/data/models/screening.dart';

abstract class ScreeningRepository {
  Future<Screening?> getScreeningForDonation(int donationId);
  Future<Screening> createScreening(Screening screening);
  Future<List<Donation>> getDonationsPendingScreening();
}
