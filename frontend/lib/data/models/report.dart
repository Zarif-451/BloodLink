class Report {
  const Report({
    required this.id,
    required this.generatedByUserId,
    required this.generatedOn,
    required this.title,
    required this.summary,
  });

  final int id;
  final int generatedByUserId;
  final DateTime generatedOn;
  final String title;
  final String summary;
}
