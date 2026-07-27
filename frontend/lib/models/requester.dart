class Requester {
  final String requesterID;
  final String requesterType;
  final String name;
  final String street;
  final String area;
  final String city;

  const Requester({
    required this.requesterID,
    required this.requesterType,
    required this.name,
    required this.street,
    required this.area,
    required this.city,
  });

  factory Requester.fromJson(Map<String, dynamic> json) {
    return Requester(
      requesterID: json['requester_ID'] as String,
      requesterType: json['requester_type'] as String,
      name: json['name'] as String,
      street: json['street'] as String,
      area: json['area'] as String,
      city: json['city'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requester_type': requesterType,
      'name': name,
      'street': street,
      'area': area,
      'city': city,
    };
  }
}