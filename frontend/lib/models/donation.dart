class Donation {
  final String donationID;
  final int unitsDonated;
  final String donationDate;
  final String donor;

  const Donation({
    required this.donationID,
    required this.unitsDonated,
    required this.donationDate,
    required this.donor,
  });

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      donationID: json['donation_ID'] as String,
      unitsDonated: json['units_donated'] as int,
      donationDate: json['donation_date'] as String,
      donor: json['donor'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'units_donated': unitsDonated,
      'donation_date': donationDate,
      'donor': donor,
    };
  }
}