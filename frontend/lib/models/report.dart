class Report {
  final String reportID;
  final String generatedOn;
  final String reportData;
  final String user;

  const Report({
    required this.reportID,
    required this.generatedOn,
    required this.reportData,
    required this.user,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      reportID: json['report_ID'] as String,
      generatedOn: json['generated_on'] as String,
      reportData: json['report_data'] as String,
      user: json['user'] as String,
    );
  }
}