class Transport {
  final String transportID;
  final String destinationType;
  final String destinationName;
  final String transportDate;
  final String status;
  final String branch;

  const Transport({
    required this.transportID,
    required this.destinationType,
    required this.destinationName,
    required this.transportDate,
    required this.status,
    required this.branch,
  });

  factory Transport.fromJson(Map<String, dynamic> json) {
    return Transport(
      transportID: json['transport_ID'] as String,
      destinationType: json['destination_type'] as String,
      destinationName: json['destination_name'] as String,
      transportDate: json['transport_date'] as String,
      status: json['status'] as String,
      branch: json['branch'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'destination_type': destinationType,
      'destination_name': destinationName,
      'transport_date': transportDate,
      'status': status,
      'branch': branch,
    };
  }
}