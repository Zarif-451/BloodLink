import 'package:frontend/data/models/donor.dart';

abstract class DonorRepository {
  Future<List<Donor>> getDonors({String? query});
  Future<Donor?> getDonor(String nationalId);
  Future<Donor> createDonor(Donor donor);
  Future<Donor> updateDonor(Donor donor);
}
