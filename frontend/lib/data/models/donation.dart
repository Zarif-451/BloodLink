class Donation {
  const Donation({
    required this.id,
    required this.nationalId,
    required this.unitsDonated,
    required this.donationDate,
    this.eligibleNextDate,
    this.notes,
  });

  final int id;
  final String nationalId;
  final int unitsDonated;
  final DateTime donationDate;
  final DateTime? eligibleNextDate;
  final String? notes;
}
